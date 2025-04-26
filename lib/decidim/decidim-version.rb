module Decidim
  class DecidimVersion
    attr_reader :decidim, :branch
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
        RUBY_VERSION: stable_ruby_version,
        VCS_REF: checksum,
        VERSION: decidim_version,
        BUILD_DATE: DateTime.now.iso8601
      }
    end

    def checksum
      @checksum ||= decidim.on_cloned_repository(branch) do
        %x(git rev-parse HEAD)
      end
    end

    def updated_at
      @updated_at ||= decidim.on_cloned_repository(branch) do
        %x(git log -1 --pretty=format:"%ad" --date=short)
      end
    end

    def decidim_version
      @decidim_version ||= gemfile_lock.specs.find { |spec| spec.name == "decidim" }.version.to_s
    end

    def node_version
      return "" unless valid_node_engines?
      @node_version ||= package_json["engines"]["node"]
    end

    # >=22.2 ~> 22
    def node_major_version
      return "" unless valid_node_engines?
      @node_major_version ||= node_version.split(".").first.match(/(\d+)$/)[0].to_i 
    end

    def npm_version
      return "" unless valid_node_engines?
      @npm_version ||= package_json["engines"]["npm"]
    end

    def ruby_version
      @ruby_version ||= gemfile_lock.ruby_version.to_s
    end

    def stable_ruby_version
      ruby_version.match(/^(ruby )(\d+\.\d+\.\d+)/)[2]
    end

    def bundler_version
      @bundler_version ||= gemfile_lock.bundler_version.to_s
    end

    def valid_node_engines?
      package_json.has_key?("engines") && package_json["engines"].has_key?("node")
    end

    def as_json
      return {updated_at: updated_at, decidim_version: decidim_version, args: docker_args} unless valid_node_engines?
      {
        updated_at: updated_at,
        decidim_version: decidim_version,
        args: docker_args
      }
    end

    def gemfile_lock
      @gemfile_lock ||= decidim.on_cloned_repository(branch) do
        Bundler::LockfileParser.new(
          Bundler.read_file(Dir.pwd + "/Gemfile.lock")
        )
      end
    end
    private 


    def package_json
      @package_json ||= decidim.on_cloned_repository(branch) do 
        JSON.parse(File.read("package.json")) 
      end
    end
  end
end