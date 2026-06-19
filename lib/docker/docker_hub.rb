# frozen_string_literal: true

module Docker
  class DockerHub
    include Singleton

    class << self
      delegate :client, to: :instance
      delegate :repositories, to: :instance

      def configure!
        return if @configured

        raise "DOCKER_HUB_ACCESS_TOKEN is not set" if ENV.fetch("DOCKER_HUB_ACCESS_TOKEN", "").empty?

        DockerHubClient.configure do |config|
          config.username = ENV.fetch("DOCKER_HUB_USERNAME")
          config.password = ENV.fetch("DOCKER_HUB_ACCESS_TOKEN")
        end
        @configured = true
      end
    end

    def client
      self.class.configure!
      @client ||= DockerHubClient::ApiClient.new
    end

    def repositories
      self.class.configure!
      @repositories ||= DockerHubClient::RepositoriesApi.new(client)
    end
  end
end
