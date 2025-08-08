require 'dotenv/load'
require 'erb'
require 'active_support/core_ext/string'
require_relative './lib/docker'


task :"docker:build:ubuntu", [:version] do |_, args|
  Docker::Ubuntu.instance.versionned_tag_names.first(3).each do |tag|
    tag_version = tag.first
    tag_codename = tag.last
    Docker::Task.put "Building ubuntu:#{tag_version} (#{tag_codename})"

    version = case args[:version]
      when "dev" then Decidim::Decidim.instance.versions[0]
      when "last" then Decidim::Decidim.instance.versions[1]
      when "prev" then Decidim::Decidim.instance.versions[2]
      else
        Docker::Task.help
        exit 1
    end

    docker_args_h = {UBUNTU_TAG: tag_version}.merge(version.docker_args)
    decidim_tag = "#{tag_codename}-#{version.decidim_version}"
    docker_args = docker_args_h.map do |key, value|
      "--build-arg='#{key}=#{value}'"
    end.join(" ")
    docker_cmd = ["docker", "build", "--file=docker/Dockerfile.ubuntu", "--tag=decidim:#{decidim_tag}", *docker_args].join(" ")
    docker_cmd += " ./docker"

    Docker::Task.put("Build Arguments\n#{docker_args_h.map { |key, value| "  * #{key}: #{value}" }.join("\n")}")
    Docker::Task.system!(
      docker_cmd
    )
  end
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:clean", [] do
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:push:ubuntu", [:version] do |_, args|
  if ENV["DOCKER_HUB_REGISTRY"].nil?
    Docker::Task.put("DOCKER_HUB_REGISTRY is not set")
    Docker::Task.help
    exit 1
  end
  registry_username = ENV["DOCKER_HUB_REGISTRY"]

  Docker::Ubuntu.instance.versionned_tag_names.first(3).each_with_index do |tag, index|
    tag_version = tag.first
    tag_codename = tag.last
    
    version = case args[:version]
    when "dev" then Decidim::Decidim.instance.versions[0]
    when "last" then Decidim::Decidim.instance.versions[1]
    when "prev" then Decidim::Decidim.instance.versions[2]
    else
      Docker::Task.help
      exit 1
    end
    source_tag = "#{tag_codename}-#{version.decidim_version}"
    Docker::Task.put("Prepare #{version.decidim_version}")
    if index == 0
      version.parsed_version[1..].each do |dest_version|
        dest_version = "#{dest_version}"
        destination_tag = "#{registry_username}/decidim:#{dest_version}"
        Docker::Task.put("tagging #{destination_tag}")
        
        Docker::Task.system!("docker", "tag", "decidim:#{source_tag}", destination_tag)
        if ENV["DRY_RUN"] == "1"
          Docker::Task.put("DRY_RUN: skip push")
        else
          Docker::Task.system!("docker", "push", destination_tag)
          Docker::Task.put("pushed #{destination_tag}")
        end
      end
    end
    # 0.29.2 will push tags for `0.29` and `0.29.2`
    version.parsed_version[1..].each do |dest_version|
      dest_version = "#{tag_codename}-#{dest_version}"
      destination_tag = "#{registry_username}/decidim:#{dest_version}"
      Docker::Task.put("tagging #{destination_tag}")
      
      Docker::Task.system!("docker", "tag", "decidim:#{source_tag}", destination_tag)
      if ENV["DRY_RUN"] == "1"
        Docker::Task.put("DRY_RUN: skip push")
      else
        Docker::Task.system!("docker", "push", destination_tag)
        Docker::Task.put("pushed #{destination_tag}")
      end
    end
  end
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:docs", [] do 
  base_image_tag = Docker::Ubuntu.instance.latest
  versions = Decidim::Decidim.instance.versions

  template_vars = {
    github_repository: ENV.fetch("GITHUB_REPOSITORY", "decidim/docker"),
    github_ref_name: ENV.fetch("GITHUB_REF_NAME", "master"),
    develop_version: versions[0],
    last_version: versions[1],
    prev_version: versions[2],
    base_image_tag: base_image_tag.first,
    base_image_alternatives: Docker::Ubuntu.instance.versionned_tag_names.first(3)
  }
  # Foreach templates/**/* files, read the file, replace the variables and write the result
  Dir.glob(File.join(__dir__, "templates", "**", "*.erb")).each do |file|
    template = File.read(file)
    destination = file.gsub("templates", ".").gsub(".erb", "")
    FileUtils.mkdir_p(File.dirname(destination))
    Docker::Task.put("Generating #{destination}")
    File.write(destination, ERB.new(template).result_with_hash(template_vars))
  end
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end
