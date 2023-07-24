#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_buster_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'

DOCKERHUB_USERNAME = ENV.fetch("DOCKERHUB_USERNAME", "decidim")
DECIDIM_VERSIONS = ENV.fetch("DECIDIM_VERSION_BRANCHES", "release/0.27-stable,develop").split(",")

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
    system(docker_cmd)
    docker_cmd = "docker build -t #{source_tag}-dev \
            #{is_stable ? "" : '--build-arg GENERATOR_PARAMS=--edge'} \
            --build-arg DECIDIM_VERSION=#{is_stable ? decidim_version_string : ""} \
            --build-arg BUILD_WITHOUT="" \
            --build-arg BASE_IMAGE=ruby:#{docker.buster_tag} \
            --build-arg VERSION=#{decidim_version_string} \
            --build-arg BUNDLER_VERSION=#{bundler_version} \
            --build-arg NODE_MAJOR_VERSION=#{node_major_version} \
            --build-arg BUILD_DATE=#{build_date} \
            --build-arg VCS_REF=#{docker.decidim_version.commit_rev} \
        -f ./dockerfiles/build/Dockerfile ./bundle"
    puts docker_cmd
    system(docker_cmd)
    docker_cmd = `docker build -t #{source_tag}-dist \
            --build-arg FROM_IMAGE=#{source_tag}-build \
            --build-arg BUNDLER_VERSION=#{bundler_version} \
            --build-arg BASE_IMAGE=ruby:#{docker.slim_buster_tag} \
            --build-arg BUILD_DATE=#{build_date} \
            --build-arg NODE_MAJOR_VERSION=#{node_major_version} \
            --build-arg VCS_REF=#{docker.decidim_version.commit_rev} \
        -f ./dockerfiles/dist/Dockerfile ./bundle`
    puts docker_cmd
    system(docker_cmd)
    
    if is_stable
        # Stable versions 0.27.3 => publish to 0.27 and 0.27.3
        tag_versions(docker.decidim_version.version) do |version|
            image = "#{DOCKERHUB_USERNAME}/decidim:#{version}"
            last_stable = image
            build_command = "docker tag #{source_tag}-build #{image}-build"
            dev_command = "docker tag #{source_tag}-dev #{image}-dev"
            dist_command = "docker tag #{source_tag}-dist #{image}"
            if push_to_dockerhub?
                system("#{build_command}")
                system("#{dev_command}")
                system("#{dist_command}")
                system("docker push #{image}-build")
                system("docker push #{image}-dev")
                system("docker push #{image}")
                else
                puts "--dry-run: #{build_command}"
                puts "--dry-run: #{dev_command}"
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
            system("#{build_command}")
            system("#{dev_command}")
            system("#{dist_command}")
            system("docker push #{image}-build")
            system("docker push #{image}-dev")
            system("docker push #{image}")
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
        system("docker push latest-build")
        system("docker push latest-dev")
        system("docker push latest")
    end
end
