# frozen_string_literal: true

module Docker
  class Redhat
    include Singleton
    include Docker::Concern::DockerHubImage
    
    def name
      "Redhat"
    end

    def version_count
      2
    end
    
    def latest
      @latest ||= versionned_tag_names.first
    end


    def repository
      @repository ||= discover_ubi_repositories.first.last
    end

    def versionned_tags
      @versionned_tags ||= discover_ubi_repositories.map do |codename|
        version_tag = redhat_tags("redhat/#{codename}").first
        TagPresenter.new(self, codename, version_tag.name)
      end
    end

    private 

    def discover_ubi_repositories
      @discovered_ubi_repositories ||= begin
      # discover UBI repositories dynamically
      discovered = []

      # Method 2: If no common patterns found, try sequential discovery
        (8..).each do |version|
          repo_name = "ubi#{version}"
          break unless repository_exists?("redhat/#{repo_name}")
          discovered << repo_name
        end
        discovered.reverse
      end
    end

    def redhat_tags(redhat_repo)
      result = repository_api.v2_namespaces_namespace_repositories_repository_tags_get_with_http_info(
        *redhat_repo.split("/"),
        { page: 1, page_size: 100 }
      )
      result.map do |paginated_tags|
        next [] unless paginated_tags.respond_to?(:results)
        paginated_tags.results.filter do |tag|
          tag.name.match?(/^\d+\.\d+$/) || !tag.name || "#{tag.name}".empty?
        end.compact
      end.flatten.compact
    end

    def repository_exists?(repo_name)
      namespace, repository = repo_name.split("/")
      begin
        # Use HEAD request to check if repository exists
        repository_api.v2_namespaces_namespace_repositories_repository_tags_head_with_http_info(
          namespace, repository
        )
        true
      rescue => e
        false
      end
    end
  end
end
