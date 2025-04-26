# frozen_string_literal: true

module Docker
  class DockerHub
    include Singleton

    class << self
      delegate :client, to: :instance
      delegate :repositories, to: :instance
    end

    def client
      @client ||= DockerHubClient::ApiClient.new
    end

    def repositories
      @repositories ||= DockerHubClient::RepositoriesApi.new(client)
    end
  end
end
