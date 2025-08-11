# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "byebug" if ENV.fetch("RAILS_ENV", "production") == "development"
require "docker_hub_client"
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/concerning'
require 'active_support/configurable'
require 'singleton'

require_relative 'docker/task'
require_relative 'docker/docker_hub'
require_relative 'docker/concern/docker_hub_image'
require_relative 'docker/tag_presenter'
require_relative 'docker/ubuntu'
require_relative 'docker/redhat'

require_relative 'decidim/decidim-version'
require_relative 'decidim/decidim'
require_relative 'initializers/configure_docker_hub'

module Docker
  include ActiveSupport::Configurable

  config_accessor :verbose do
    false
  end
end