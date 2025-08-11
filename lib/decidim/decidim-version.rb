module Decidim
  class DecidimVersion
    attr_reader :decidim, :branch
    alias :decidim_branch :branch

    def initialize(decidim, branch)
      @decidim = decidim
      @branch = branch
    end

    def docker_args
      {
        DECIDIM_VERSION: decidim_version,
        DECIDIM_BRANCH: branch,
        NODE_MAJOR_VERSION: node_major_version,
        BUNDLER_VERSION: bundler_version,
        RUBY_VERSION: ruby_version,
        VCS_REF: checksum,
        VCS_REF_SHORT: checksum[0..7],
        VCS_REF_DATE: updated_at,
        VERSION: decidim_version,
        BUILD_DATE: DateTime.now.iso8601.to_s
      }
    end

    ##
    # For a given decidim version eg "0.29.4"
    # return all the aliases: 
    # - 0
    # - 0.29
    # - 0.29.4
    # @return [Array<String>]
    def version_aliases
      parsed = decidim_version.split(".")
      prev_version = parsed.first
      results = [prev_version]
      parsed[1..].each do |version_seg|
        prev_version = "#{prev_version}.#{version_seg}"
        results << prev_version
      end
      results
    end

    ##
    # Return the git commit hash for the version
    def checksum
      @checksum ||= decidim.on_cloned_repository(branch) do
        %x(git rev-parse HEAD)
      end.strip
    end

    ##
    # Return the date of the last commit for the version
    def updated_at
      @updated_at ||= decidim.on_cloned_repository(branch) do
        %x(git log -1 --pretty=format:"%ad" --date=short)
      end.strip
    end

    ##
    # Return the decidim version from the gemfile.lock
    def decidim_version
      @decidim_version ||= gemfile_lock.specs.find { |spec| spec.name == "decidim" }.version.to_s
    end

    ##
    # Required node version for the decidim version.
    def node_version
      return "" unless valid_node_engines?
      @node_version ||= package_json["engines"]["node"]
    end

    ##
    # Return the major node version for the decidim version.
    # eg: ">= 22.2" will return 22
    def node_major_version
      return "" unless valid_node_engines?
      @node_major_version ||= node_version.split(".").first.match(/(\d+)$/)[0].to_i 
    end

    ##
    # Return the npm version for the decidim version.
    def npm_version
      return "" unless valid_node_engines?
      @npm_version ||= package_json["engines"]["npm"]
    end

    ##
    # Return the ruby version for the decidim version.
    def gemfile_ruby_version
      @ruby_version ||= gemfile_lock.ruby_version.to_s
    end

    ##
    # Return the stable ruby version for the decidim version.
    # eg: "ruby 3.3.3" will return 3.3.3
    def ruby_version
      gemfile_ruby_version.match(/^(ruby )(\d+\.\d+\.\d+)/)[2]
    end

    ##
    # Return the bundler version for the decidim version.
    def bundler_version
      @bundler_version ||= gemfile_lock.bundler_version.to_s
    end

    ##
    # Return true if the node engines are valid for the decidim version.
    def valid_node_engines?
      package_json.has_key?("engines") && package_json["engines"].has_key?("node")
    end

    ##
    # Return the decidim version as a hash.
    # (for debug purposes)
    def as_json
      return { updated_at: updated_at, decidim_version: decidim_version, args: docker_args } unless valid_node_engines?
      {
        updated_at: updated_at,
        decidim_version: decidim_version,
        args: docker_args
      }
    end


    private 

      ##
      # Return the gemfile.lock for the decidim version.
      def gemfile_lock
        @gemfile_lock ||= decidim.on_cloned_repository(branch) do
          Bundler::LockfileParser.new(
            Bundler.read_file(Dir.pwd + "/Gemfile.lock")
          )
        end
      end
      
      def package_json
        @package_json ||= decidim.on_cloned_repository(branch) do 
          JSON.parse(File.read("package.json")) 
        end
      end
  end
end
