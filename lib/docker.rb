# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "byebug" if ENV.fetch("RAILS_ENV", "development") == "development"
require "docker_hub_client"
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/concerning'
require 'singleton'

require_relative 'docker/task'
require_relative 'docker/docker_hub'
require_relative 'docker/concern/docker_hub_image'
require_relative 'docker/ubuntu'

require_relative 'decidim/decidim-version'
require_relative 'decidim/decidim'
require_relative 'initializers/configure_docker_hub'
