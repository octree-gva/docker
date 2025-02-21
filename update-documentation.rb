#!/usr/bin/env ruby

require_relative 'lib/decidim_version'
require_relative 'lib/ruby_repo'
require_relative 'lib/docker_image'
require_relative 'lib/helpers'
require "erb"

REGISTRY_USERNAME = ENV.fetch("REGISTRY_USERNAME", "decidim")
DECIDIM_VERSIONS_COUNT = ENV.fetch("DECIDIM_VERSION_COUNT", "2").to_i

supported_versions = []
begin
    system("git", "clone", "--bare", "https://github.com/decidim/decidim.git", "decidim-repo")
    Dir.chdir('decidim-repo') do 
        branches = `git branch --list 'release/*-stable' | sort -V | tail -n #{DECIDIM_VERSIONS_COUNT}`
        branch_list = branches.split("\n")
        supported_versions = [*branch_list, "develop"].map do |branch|
            DecidimVersion.new(branch.gsub(/\s+/, ' ').strip)
        end
    end
ensure
    system("rm", "-rf", "decidim-repo")
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
                "ruby:#{docker.ruby_tag}",
                "node_#{node_major_version}_x",
                "docker-compose -f decidim.#{version}.yml up"
            ])
            stable_images.push(
                "[:#{version}](https://hub.docker.com/r/#{REGISTRY_USERNAME}/decidim/tags?page=1&name=#{version})"
            )
            File.write("./docker-compose.#{version}.yml", template_quickstart.result_with_hash(
                is_stable: true,
                registry_username: REGISTRY_USERNAME,
                docker_tag: "#{REGISTRY_USERNAME}/decidim:#{version}"
            ))
            File.write("./docker-compose.#{version}.dev.yml", template_quickstart.result_with_hash(
                is_stable: false,
                registry_username: REGISTRY_USERNAME,
                docker_tag: "#{REGISTRY_USERNAME}/decidim:#{version}-dev"
            ))
            # Write down only one version in the README.
            break
        end
    else
        dev_images.push(
            "[:nightly](https://hub.docker.com/r/#{REGISTRY_USERNAME}/decidim/tags?page=1&name=nightly)"
        )
        decidim_table.push([
            docker.decidim_version.github_branch,
            "ruby:#{docker.ruby_tag}",
            "node_#{node_major_version}_x",
            "docker-compose -f decidim.nightly.yml up"
        ])
        File.write("./docker-compose.nightly.yml", template_quickstart.result_with_hash(
            is_stable: false,
            docker_tag: "#{REGISTRY_USERNAME}/decidim:nightly-dev",
            registry_username: REGISTRY_USERNAME
        ))
    end
end

readme_locals = {
    stable_images: stable_images,
    dev_images: dev_images,
    last_stable: last_stable,
    decidim_table: decidim_table,
    registry_username:  REGISTRY_USERNAME
}
File.write("./README.md", template_readme.result_with_hash(readme_locals))
Dir["templates/docs/*.erb"].map do |file_path|
    file_name = File.basename(file_path, ".erb")
    File.write("./docs/#{file_name}", ERB.new(File.read(file_path)).result_with_hash(readme_locals))
end
# Write Table of Content for all the docs.
`doctoc README.md ./docs/*.md`
