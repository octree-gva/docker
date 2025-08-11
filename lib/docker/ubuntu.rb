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

    def versionned_tags
      @versionned_tags ||= begin
        picked_major_versions = []
        tag_names = tags do |tag|
          next unless !tag.name || "#{tag.name}".empty? || tag.name.match?(/^\d+\.\d+$/)
          major_version = "#{tag.name}".split(".").first
          next if picked_major_versions.include?(major_version)
          picked_major_versions << major_version
          tag.name
        end.select { |tag| !tag.nil? }
        tag_names.map do  |tag_name| 
          TagPresenter.new(self, codename_for(tag_name), tag_name)
        end
      end
    end
  end
end
