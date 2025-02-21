#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'
require "erb"
REGISTRY_USERNAME = ENV.fetch("REGISTRY_USERNAME", "decidim")
DECIDIM_VERSIONS_COUNT = ENV.fetch("DECIDIM_VERSION_COUNT", "2").to_i

template_docker_compose = ERB.new(File.read('templates/container-docker-compose.yml.erb'))
template_dockerfile = ERB.new(File.read('templates/container-Dockerfile.erb'))
supported_versions = []
begin
    system("git", "clone", "--bare", "https://github.com/decidim/decidim.git", "decidim-repo")
    Dir.chdir('decidim-repo') do 
        supported_versions.push(DecidimVersion.new("develop"))
        if DECIDIM_VERSIONS_COUNT > 0
            branches = `git branch --list 'release/*-stable' | sort -V | tail -n #{DECIDIM_VERSIONS_COUNT}`
            branch_list = branches.split("\n")
            supported_versions.concat(branch_list.map do |branch|
                DecidimVersion.new(branch.gsub(/\s+/, ' ').strip)
            end)
        end
    end
ensure
    system("rm", "-rf", "decidim-repo")
end



image = "#{REGISTRY_USERNAME}/decidim"
errors = []
supported_versions.map do |version| 
    docker_image = DockerImage.new(version)
    decidim_version_string = docker_image.version.join(".")
    is_stable = docker_image.github_branch.include?("stable")
    source_tag = "decidim:#{is_stable ? decidim_version_string : "nightly"}"
    File.write("./bundle/docker-compose.yml", template_docker_compose.result_with_hash(
        is_stable: is_stable,
    ))
    File.write("./bundle/Dockerfile", template_dockerfile.result_with_hash(
        docker_tag: "#{REGISTRY_USERNAME}/decidim:#{docker_image.version.first(2).join(".")}-onbuild",
    ))
    begin
        build_images(docker_image, image)
        if is_stable
            # Stable versions 0.27.3 => publish to 0.27 and 0.27.3
            tag_versions(docker_image.version) do |version|
                push_image("#{source_tag}-onbuild", "#{image}:#{version}-onbuild")
                push_image("#{source_tag}-dev", "#{image}:#{version}-dev")
                push_image("#{source_tag}", "#{image}:#{version}")
            end
        else
            version = docker_image.github_branch
            push_image("#{source_tag}-onbuild", "#{image}:nightly-onbuild")
            push_image("#{source_tag}-dev", "#{image}:nightly-dev")
            push_image("#{source_tag}", "#{image}:nightly")
        end
        # Clean all the images and cache before continuing
        system("docker", "system", "prune", "-af")
    rescue => error
        errors.push("Errors on #{source_tag}. #{error}")
    end
end

raise "UPDATE FAILED. #{errors.join("\n")}" if errors.count > 0

