require 'dotenv/load'
require_relative './lib/docker'

task :"docker:build", [:version] do |_, args|
  latest_tag = Docker::Ubuntu.instance.latest
  Docker::Task.put "Building ubuntu:#{latest_tag}"

  version = case args[:version]
    when "dev" then Decidim::Decidim.instance.versions.first
    when "last" then Decidim::Decidim.instance.versions[1]
    when "prev" then Decidim::Decidim.instance.versions[2]
    else
      Docker::Task.help
      exit 1
  end

  docker_args_h = {UBUNTU_TAG: latest_tag}.merge(version.docker_args)
  docker_args = docker_args_h.map do |key, value|
    "--build-arg='#{key}=#{value}'"
  end.join(" ")
  docker_cmd = ["docker", "build", "--tag=decidim:#{version.decidim_version}", *docker_args].join(" ")
  # Build with no context
  docker_cmd += " - < ./Dockerfile"

  Docker::Task.put("Build Arguments\n#{docker_args_h.map { |key, value| "  * #{key}: #{value}" }.join("\n")}")
  Docker::Task.system!(
    docker_cmd
  )
ensure
  Decidim::Decidim.instance.clean_clone
end
