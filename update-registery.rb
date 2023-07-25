#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_buster_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'
require "erb"
DOCKERHUB_USERNAME = ENV.fetch("DOCKERHUB_USERNAME", "decidim")
DECIDIM_VERSIONS = ENV.fetch("DECIDIM_VERSION_BRANCHES", "release/0.27-stable,develop").split(",")

template_docker_compose = ERB.new(File.read('templates/container-docker-compose.yml.erb'))
template_dockerfile = ERB.new(File.read('templates/container-Dockerfile.erb'))
supported_versions = []
begin
    system("git clone --bare https://github.com/decidim/decidim.git decidim-repo")
    Dir.chdir('decidim-repo') do 
        supported_versions = DECIDIM_VERSIONS.map{|branch| DecidimVersion.new(branch) }
    end
ensure
    system("rm -rf decidim-repo")
end

last_stable = ""
supported_versions.map do |version| 
    docker = DockerImage.new(version)
    decidim_version_string = docker.decidim_version.version.join(".")
    source_tag = "decidim:#{decidim_version_string}"
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%MZ")
    is_stable = docker.decidim_version.github_branch.include?("stable")
    node_major_version = docker.decidim_version.node_version[0]
    bundler_version = docker.decidim_version.bundler_version.join(".")
    File.write("./bundle/docker-compose.yml", template_docker_compose.result_with_hash(
        is_stable: is_stable,
    ))
    File.write("./bundle/Dockerfile", template_dockerfile.result_with_hash(
        docker_tag: "#{DOCKERHUB_USERNAME}/decidim:#{docker.decidim_version.version.first(2).join(".")}",
    ))
    docker_cmd = "docker build -t #{source_tag}-build \
            #{is_stable ? "" : '--build-arg GENERATOR_PARAMS=--edge'} \
            --build-arg DECIDIM_VERSION=#{is_stable ? decidim_version_string : ""} \
            --build-arg BUILD_WITHOUT=development:test \
            --build-arg BASE_IMAGE=ruby:#{docker.buster_tag} \
            --build-arg VERSION=#{decidim_version_string} \
            --build-arg BUNDLER_VERSION=#{bundler_version} \
            --build-arg NODE_MAJOR_VERSION=#{node_major_version} \
            --build-arg BUILD_DATE=#{build_date} \
            --build-arg VCS_REF=#{docker.decidim_version.commit_rev} \
        -f ./dockerfiles/build/Dockerfile ./bundle"
    puts docker_cmd
    raise "docker failed to build #{decidim_version_string}-build image" unless system(docker_cmd)
    docker_cmd = "docker build -t #{source_tag}-dev \
            #{is_stable ? "" : '--build-arg GENERATOR_PARAMS=--edge'} \
            --build-arg DECIDIM_VERSION=#{is_stable ? decidim_version_string : ""} \
            --build-arg FROM_IMAGE=#{source_tag}-build \
            --build-arg GROUP_ID=1001 \
            --build-arg USER_ID=1001 \
            --build-arg BUILD_WITHOUT="" \
            --build-arg BASE_IMAGE=ruby:#{docker.buster_tag} \
            --build-arg VERSION=#{decidim_version_string} \
            --build-arg RAILS_ENV=development \
            --build-arg BUNDLER_VERSION=#{bundler_version} \
            --build-arg NODE_MAJOR_VERSION=#{node_major_version} \
            --build-arg BUILD_DATE=#{build_date} \
            --build-arg VCS_REF=#{docker.decidim_version.commit_rev} \
        -f ./dockerfiles/dist/Dockerfile ./bundle"
    puts docker_cmd
    raise "docker failed to build #{decidim_version_string}-dev image" unless system(docker_cmd)
    docker_cmd = `docker build -t #{source_tag}-dist \
            --build-arg FROM_IMAGE=#{source_tag}-build \
            --build-arg BUNDLER_VERSION=#{bundler_version} \
            --build-arg BASE_IMAGE=ruby:#{docker.slim_buster_tag} \
            --build-arg BUILD_DATE=#{build_date} \
            --build-arg RAILS_ENV=production \
            --build-arg GROUP_ID=1001 \
            --build-arg USER_ID=1001 \
            --build-arg NODE_MAJOR_VERSION=#{node_major_version} \
            --build-arg VCS_REF=#{docker.decidim_version.commit_rev} \
        -f ./dockerfiles/dist/Dockerfile ./bundle`
    puts docker_cmd
    raise "docker failed to build #{decidim_version_string} image" unless system(docker_cmd)
    docker_cmd = `docker build -t #{source_tag}-selfservice \
            --build-arg BASE_IMAGE=#{source_tag}-dist \
        -f ./dockerfiles/selfservice/Dockerfile ./bundle`
    puts docker_cmd
    raise "docker failed to build #{decidim_version_string}-selfservice image" unless system(docker_cmd)
    
    if is_stable
        # Stable versions 0.27.3 => publish to 0.27 and 0.27.3
        tag_versions(docker.decidim_version.version) do |version|
            image = "#{DOCKERHUB_USERNAME}/decidim:#{version}"
            last_stable = image
            build_command = "docker tag #{source_tag}-build #{image}-build"
            dev_command = "docker tag #{source_tag}-dev #{image}-dev"
            selfservice_command = "docker tag #{source_tag}-selfservice #{image}-selfservice"
            dist_command = "docker tag #{source_tag}-dist #{image}"
            if push_to_dockerhub?
                raise "docker failed to tag #{decidim_version_string}-build" unless system("#{build_command}")
                raise "docker failed to tag #{decidim_version_string}-dev" unless system("#{dev_command}")
                raise "docker failed to tag #{decidim_version_string}" unless system("#{dist_command}")
                raise "docker failed to tag #{decidim_version_string}-selfservice" unless system("#{selfservice_command}")
                raise "docker failed to push #{decidim_version_string}-build" unless system("docker push #{image}-build")
                raise "docker failed to push #{decidim_version_string}-dev" unless system("docker push #{image}-dev")
                raise "docker failed to push #{decidim_version_string}" unless system("docker push #{image}")
                raise "docker failed to push #{decidim_version_string}-selfservice" unless system("docker push #{image}-selfservice")
            else
                puts "--dry-run: #{build_command}"
                puts "--dry-run: #{dev_command}"
                puts "--dry-run: #{selfservice_command}"
                puts "--dry-run: #{dist_command}"
            end    
        end
    else
        version = docker.decidim_version.github_branch
        image = "#{DOCKERHUB_USERNAME}/decidim:#{version}"
        build_command = "docker tag #{source_tag}-build #{image}-build"
        dev_command = "docker tag #{source_tag}-dev #{image}-dev"
        dist_command = "docker tag #{source_tag}-dist #{image}"
        if push_to_dockerhub?
            raise "docker failed to tag #{decidim_version_string}-build" unless system("#{build_command}")
            raise "docker failed to tag #{decidim_version_string}-dev" unless system("#{dev_command}")
            raise "docker failed to tag #{decidim_version_string}" unless system("#{dist_command}")
            raise "docker failed to push #{decidim_version_string}-build" unless system("docker push #{image}-build")
            raise "docker failed to push #{decidim_version_string}-dev" unless system("docker push #{image}-dev")
            raise "docker failed to push #{decidim_version_string}" unless system("docker push #{image}")
        else
            puts "--dry-run: #{build_command}"
            puts "--dry-run: #{dev_command}"
            puts "--dry-run: #{dist_command}"
        end
    end
end

if last_stable
    build_command = "docker tag #{last_stable}-build latest-build"
    dev_command = "docker tag #{last_stable}-dev latest-dev"
    dist_command = "docker tag #{last_stable}-dist latest"
    if push_to_dockerhub?
        raise "docker failed to push latest-build" unless system("docker push latest-build")
        raise "docker failed to push latest-dev" unless system("docker push latest-dev")
        raise "docker failed to push latest" unless system("docker push latest")
    end
end
