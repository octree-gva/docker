# frozen_string_literal: true
require "docker_hub_client"
require 'active_support/core_ext/module/delegation'
require 'singleton'

require_relative 'docker/task'
require_relative 'docker/docker_hub'
require_relative 'docker/ubuntu'

require_relative 'decidim/decidim-version'
require_relative 'decidim/decidim'
require_relative 'initializers/configure_docker_hub'
