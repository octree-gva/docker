#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_buster_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'
require "erb"
REGISTERY_USERNAME = ENV.fetch("REGISTERY_USERNAME", "decidim")
DECIDIM_VERSIONS = ENV.fetch("DECIDIM_VERSION_BRANCHES", "release/0.27-stable").split(",")

template_docker_compose = ERB.new(File.read('templates/container-docker-compose.yml.erb'))
template_dockerfile = ERB.new(File.read('templates/container-Dockerfile.erb'))
supported_versions = []
begin
    system("git", "clone", "--bare", "https://github.com/decidim/decidim.git", "decidim-repo")
    Dir.chdir('decidim-repo') do 
        supported_versions = DECIDIM_VERSIONS.map{|branch| DecidimVersion.new(branch) }
    end
ensure
    system("rm", "-rf", "decidim-repo")
end

##
# Docker tag an image name to a new image name
def tag_image(source, destination)
    tag_command = ["docker", "tag", "#{source}", "#{destination}"]
    if push_to_registery?
        raise "docker failed to tag #{destination}" unless system(*tag_command)
    else
        puts "--dry-run: #{tag_command.join(" ")}"
    end
end

##
# Docker tag an image name to a destination image name, and push the latter.
def push_image(source, destination)
    tag_image(source, destination)
    push_command = ["docker", "push", "#{destination}"]
    if push_to_registery?
        raise "docker failed to push #{destination}" unless system(*push_command)
    else
        puts "--dry-run: #{push_command.join(" ")}"
    end
end

##
# Build docker images related to metadatas (version, compatible debian and node versions, etc.)
def build_images(docker_image)
    decidim_version_string = docker_image.decidim_version.version.join(".")
    source_tag = "decidim:#{decidim_version_string}"
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%MZ")
    is_stable = docker_image.decidim_version.github_branch.include?("stable")
    node_major_version = docker_image.decidim_version.node_version[0]
    bundler_version = docker_image.decidim_version.bundler_version.join(".")
    generator_params = is_stable ? [] : ["--build-arg", "GENERATOR_PARAMS=--edge"]

    docker_cmd = [
        "docker", "build",
        "-t", "#{source_tag}-onbuild",
        *generator_params,
        "--build-arg", "DECIDIM_VERSION=#{is_stable ? decidim_version_string : ''}",
        "--build-arg", "BASE_IMAGE=ruby:#{docker_image.buster_tag}",
        "--build-arg", "VERSION=#{decidim_version_string}",
        "--build-arg", "BUNDLER_VERSION=#{bundler_version}",
        "--build-arg", "NODE_MAJOR_VERSION=#{node_major_version}",
        "--build-arg", "BUILD_DATE=#{build_date}",
        "--build-arg", "VCS_REF=#{docker_image.decidim_version.commit_rev}",
        "--network=host",
        "-f", "./dockerfiles/onbuild/Dockerfile", "./bundle"
    ]
    puts docker_cmd.join(" ")
    raise "docker failed to build #{decidim_version_string}-onbuild image" unless system(*docker_cmd)
    docker_cmd = [
        "docker", "build",
        "-t", "#{source_tag}-dist",
        "--build-arg", "FROM_IMAGE=#{source_tag}-onbuild",
        "--build-arg", "BUNDLER_VERSION=#{bundler_version}",
        "--build-arg", "BASE_IMAGE=ruby:#{docker_image.slim_buster_tag}",
        "--build-arg", "BUILD_DATE=#{build_date}",
        "--build-arg", "RAILS_ENV=production",
        "--build-arg", "VERSION=#{decidim_version_string}",
        "--build-arg", "GROUP_ID=1001",
        "--build-arg", "USER_ID=1001",
        "--build-arg", "NODE_MAJOR_VERSION=#{node_major_version}",
        "--build-arg", "VCS_REF=#{docker_image.decidim_version.commit_rev}",
        "--network=host",
        "-f", "./dockerfiles/dist/Dockerfile", "./bundle"
      ]
    puts docker_cmd.join(" ")
    raise "docker failed to build #{decidim_version_string} image" unless system(*docker_cmd)
    docker_cmd = [
        "docker", "build",
        "-t", "#{source_tag}-dev",
        "--build-arg", "FROM_IMAGE=#{source_tag}-onbuild",
        "--build-arg", "BUNDLER_VERSION=#{bundler_version}",
        "--build-arg", "BASE_IMAGE=ruby:#{docker_image.slim_buster_tag}",
        "--build-arg", "BUILD_DATE=#{build_date}",
        "--build-arg", "RAILS_ENV=development",
        "--build-arg", "VERSION=#{decidim_version_string}",
        "--build-arg", "GROUP_ID=1001",
        "--build-arg", "USER_ID=1001",
        "--build-arg", "NODE_MAJOR_VERSION=#{node_major_version}",
        "--build-arg", "VCS_REF=#{docker_image.decidim_version.commit_rev}",
        "--network=host",
        "-f", "./dockerfiles/dist/Dockerfile", "./bundle"
    ]
    puts docker_cmd.join(" ")
    raise "docker failed to build #{decidim_version_string}-dev image" unless system(*docker_cmd)
    if is_stable
        docker_cmd = [
            "docker", "build",
            "-t", "#{source_tag}-selfservice",
            "--build-arg", "BASE_IMAGE=#{source_tag}-dist",
            "--no-cache", "--network=host",
            "-f", "./dockerfiles/selfservice/Dockerfile", "./bundle"
        ]
        puts docker_cmd.join(" ")
        raise "docker failed to build #{decidim_version_string}-selfservice image" unless system(*docker_cmd)
    end
end

image = "#{REGISTERY_USERNAME}/decidim"


supported_versions.map do |version| 
    docker_image = DockerImage.new(version)
    decidim_version_string = docker_image.decidim_version.version.join(".")
    source_tag = "decidim:#{decidim_version_string}"
    is_stable = docker_image.decidim_version.github_branch.include?("stable")
    File.write("./bundle/docker-compose.yml", template_docker_compose.result_with_hash(
        is_stable: is_stable,
    ))
    File.write("./bundle/Dockerfile", template_dockerfile.result_with_hash(
        docker_tag: "#{REGISTERY_USERNAME}/decidim:#{docker_image.decidim_version.version.first(2).join(".")}",
    ))
    build_images(docker_image)
    if is_stable
        # Stable versions 0.27.3 => publish to 0.27 and 0.27.3
        tag_versions(docker_image.decidim_version.version) do |version|
            push_image("#{source_tag}-onbuild", "#{image}:#{version}-onbuild")
            push_image("#{source_tag}-dev", "#{image}:#{version}-dev")
            push_image("#{source_tag}-dist", "#{image}:#{version}")
            push_image("#{source_tag}-selfservice", "#{image}:#{version}-selfservice")
        end
    else
        version = docker_image.decidim_version.github_branch
        push_image("#{source_tag}-onbuild", "#{image}:#{version}-onbuild")
        push_image("#{source_tag}-dev", "#{image}:#{version}-dev")
        push_image("#{source_tag}-dist", "#{image}:#{version}")
    end
end
