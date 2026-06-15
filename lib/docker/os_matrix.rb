# frozen_string_literal: true

require "yaml"

module Docker
  class OsMatrix
    include Singleton

    def ubuntu_tags
      @ubuntu_tags ||= load_entries("ubuntu", Docker::Ubuntu.instance)
    end

    def redhat_tags
      @redhat_tags ||= load_entries("redhat", Docker::Redhat.instance)
    end

    private

    def load_entries(distribution, image)
      entries = matrix.fetch(distribution, [])
      entries.map do |entry|
        TagPresenter.new(image, entry.fetch("name"), entry.fetch("version"))
      end
    end

    def matrix
      @matrix ||= YAML.load_file(matrix_path)
    end

    def matrix_path
      File.expand_path("../../config/os-matrix.yml", __dir__)
    end
  end
end
