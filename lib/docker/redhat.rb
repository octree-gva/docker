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
      pinned_tags.first
    end

    def pinned_tags
      Docker::OsMatrix.instance.redhat_tags
    end

    def versionned_tag_names
      pinned_tags
    end

    def versionned_tags
      pinned_tags
    end

    def repository
      pinned_tags.first&.os_name || "ubi9"
    end
  end
end
