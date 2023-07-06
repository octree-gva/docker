#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_buster_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'
require "erb"

DOCKERHUB_USERNAME = ENV.fetch("DOCKERHUB_USERNAME", "decidim")
DECIDIM_VERSIONS = ENV.fetch("DECIDIM_VERSION_BRANCHES", "release/0.27-stable,develop").split(",")

supported_versions = []
begin
    system("git clone --bare https://github.com/decidim/decidim.git decidim-repo")
    Dir.chdir('decidim-repo') do 
        supported_versions = DECIDIM_VERSIONS.map{|branch| DecidimVersion.new(branch) }
    end
ensure
    system("rm -rf decidim-repo README.md quickstart*.yml")
end

template_quickstart = ERB.new(File.read('templates/quickstart.yml.erb'))
template_readme = ERB.new(File.read('templates/README.md.erb'))

# README variables
stable_images=[]
dev_images=[]
last_stable=""
decidim_table=[]

# Loop over versions and create the documentation.
supported_versions.map do |version| 
    docker = DockerImage.new(version)
    decidim_version_string = docker.decidim_version.version.join(".")
    source_tag = "decidim:#{decidim_version_string}"
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%MZ")
    is_stable = docker.decidim_version.github_branch.include?("stable")
    node_major_version = docker.decidim_version.node_version[0]

    if is_stable
        last_stable = decidim_version_string if decidim_version_string > last_stable
        
        # Ex: stable version is 0.27.3. Then will publish to 0.27 and 0.27.3
        tag_versions(docker.decidim_version.version) do |version|
            decidim_table.push([
                decidim_version_string,
                "ruby:#{docker.buster_tag}",
                "node_#{node_major_version}_x",
                "docker-compose -f quickstart.#{version}.yml up"
            ])
            stable_images.push(
                "[:#{version}](https://hub.docker.com/r/#{DOCKERHUB_USERNAME}/decidim/tags?page=1&name=#{version})"
            )
            File.write("./quickstart.#{version}.yml", template_quickstart.result_with_hash(
                is_stable: true,
                docker_tag: "#{DOCKERHUB_USERNAME}/#{version}"
            ))
            break # Write down only one version in the README.
        end
    else
        dev_images.push(
            "[:#{docker.decidim_version.github_branch}](https://hub.docker.com/r/#{DOCKERHUB_USERNAME}/decidim/tags?page=1&name=#{docker.decidim_version.github_branch})"
        )
        decidim_table.push([
            docker.decidim_version.github_branch,
            "ruby:#{docker.buster_tag}",
            "node_#{node_major_version}_x",
            "docker-compose -f quickstart.#{docker.decidim_version.github_branch}.yml up"
        ])
        File.write("./quickstart.#{docker.decidim_version.github_branch}.yml", template_quickstart.result_with_hash(
            is_stable: false,
            docker_tag: "#{DOCKERHUB_USERNAME}/#{docker.decidim_version.github_branch}"
        ))
    end
end

File.write("./README.md", template_readme.result_with_hash(
    stable_images: stable_images,
    dev_images:dev_images,
    last_stable:last_stable,
    decidim_table:decidim_table
))