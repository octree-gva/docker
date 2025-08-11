module Docker
  class TagPresenter
    attr_reader :distribution_name, :version
    def initialize(image, distribution_name, version)
      @image = image
      @distribution_name = distribution_name
      @version = version
    end

    def docker_tag(decidim_version)
      "#{distribution_name}-#{decidim_version}"
    end

    def os_human_name
      "#{image.name.titleize} #{os_name} (#{os_version})"
    end

    def os_name
      distribution_name
    end

    def os_version
      version
    end

    def os_major_version
      version.split(".").first.to_i
    end

    private

    attr_reader :image

  end
end