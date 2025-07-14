# frozen_string_literal: true

DockerHubClient.configure do |config|
  raise "DOCKER_HUB_ACCESS_TOKEN is not set" if ENV.fetch('DOCKER_HUB_ACCESS_TOKEN', '').empty?
  # Configure Bearer authorization (JWT): bearerAuth
  config.username = ENV.fetch('DOCKER_HUB_USERNAME')
  config.password = ENV.fetch('DOCKER_HUB_ACCESS_TOKEN')
end
