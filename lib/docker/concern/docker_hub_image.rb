module Docker
  module Concern
    module DockerHubImage
      extend ActiveSupport::Concern

      included do    
        def name
          "Unknown"
        end
        def version_count
          3
        end
        def latest
          @latest ||= versionned_tag_names.first
        end

        ##
        # Get the versionned tag names
        # Will fetch the list of versionned tag names and return aan array
        # of [tag_name, codename]
        # Example: [["1.0.0", "questing"], ["1.0.1", "questing"]]
        def versionned_tag_names
          versionned_tags.first(version_count)
        end

        
        private 
        
          ##
          # Iterate over available tags of the repository to execute a block.
          def tags(&block)
            result = repository_api.v2_namespaces_namespace_repositories_repository_tags_get_with_http_info(
              *repository.split("/"),
              { page: 1, page_size: 100 }
            )
            result.map do |paginated_tags|
              next unless paginated_tags.respond_to?(:results)
              paginated_tags.results.map do |tag|
                block.call(tag)
              end.compact
            end.flatten
          end

          ##
          # Get the repository api client
          def repository_api
            @repository_api ||= Docker::DockerHub.instance.repositories
          end

          ##
          # Get a pull registry token for the repository
          # This is used to get metadatas for an image.
          def get_registry_token
            uri = URI("https://auth.docker.io/token")
            uri.query = URI.encode_www_form({
              service: "registry.docker.io",
              scope: "repository:#{repository}:pull"
            })
            
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            
            request = Net::HTTP::Get.new(uri.request_uri)
            config = Docker::DockerHub.instance.client.config
            if config.username && config.password
              request.basic_auth(config.username, config.password)
            end
          
            response = http.request(request)
            return nil unless response.code == '200'
            
            JSON.parse(response.body)["token"]
            rescue => e
              puts "Error getting registry token: #{e.message}"
              nil
          end

          ##
          # Get the codename for a tag
          # Will fetch the revisition for the given tag name and return the 
          # associated codename.
          def codename_for(target_tag_name)
            revisions_for_codenames = codenames
            target_revision = get_revision(target_tag_name)
            revisions_for_codenames[target_revision]
          end

          ##
          # Get the revision for a tag
          # Will fetch the revisition for the given tag name.
          def get_revision(tag)
            token = get_registry_token
            return nil unless token
            
            uri = URI("https://registry-1.docker.io/v2/#{repository}/manifests/#{tag}")
            
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            
            request = Net::HTTP::Get.new(uri.path)
            request['Accept'] = 'application/vnd.docker.distribution.manifest.v2+json'
            request['Authorization'] = "Bearer #{token}"
            
            response = http.request(request)
            if response.code == '429'
              raise "Rate limit exceeded, retry after 15 minutes"
            end
            return nil unless response.code == '200'
            
            data = JSON.parse(response.body)
            return nil unless data["manifests"]
            data["manifests"].first.dig("annotations", "org.opencontainers.image.revision")
          end
    
          ##
          # Foreach codename, get the revision and compose a hash
          # to retrieve the codename from the revision
          # exemple: {"1234567890": "questing"}
          def codenames
            @codenames ||= begin
              picked_codenames = []
              codenames = []
              tags do |tag|
                  next if !tag.name.match?(/^[a-z]+$/)
                  next if tag.name == "latest" || picked_codenames.include?(tag.name)
                  picked_codenames << tag.name
                  revision = get_revision(tag.name)
                  next if revision.nil?
                  codenames << [revision, tag.name]
                end
              codenames.to_h
            end
          end

      end
    end
  end
end
