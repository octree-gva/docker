# frozen_string_literal: true

module Docker
  class Ubuntu
    include Singleton
    include Docker::Concern::DockerHubImage
    def name
      "Ubuntu"
    end
    
    def repository
      "library/ubuntu"
    end

    def pinned_tags
      Docker::OsMatrix.instance.ubuntu_tags
    end

    def versionned_tag_names
      pinned_tags
    end

    def versionned_tags
      pinned_tags
    end

    def latest
      pinned_tags.first
    end
  end
end
