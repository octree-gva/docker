require 'dotenv/load'
require 'erb'
require 'active_support/core_ext/string'
require_relative './lib/docker'
require "byebug"
##
# Get the decidim version from the args. 
# This allows tasks like rake docker:build:redhat[dev] to build the dev version of the redhat image
# @param args [Hash]
# @return [Decidim::DecidimVersion]
def decidim_from_args(args)
  case args[:version]
  when "dev" then Decidim::Decidim.instance.versions[0]
  when "last" then Decidim::Decidim.instance.versions[1]
  when "prev" then Decidim::Decidim.instance.versions[2]
  when "legacy" then Decidim::Decidim.instance.versions[3]
  else
    Docker::Task.help
    exit 1
  end
end

def print_results(messages)
  Docker::Task.put("*" * 80)
  Docker::Task.put("Results:")
  messages.each do |message|
    Docker::Task.put("* " + message)
  end
  Docker::Task.put("*" * 80)
end
#
##
# Build docker images
# @param distribution_singleton [Docker::Redhat | Docker::Ubuntu]
# @param version [Decidim::DecidimVersion]
# @return [void]
def build_docker_image(distribution_singleton, version, dockerfile_path)
  last_command = nil
  distribution_singleton.versionned_tag_names.map do |tag|
    docker_args = {
      OS_VERSION: tag.os_version,
      OS_NAME: tag.os_name,
      OS_MAJOR_VERSION: tag.os_major_version,
    }.merge(version.docker_args)
    docker_args = docker_args.map do |key, value|
      "--build-arg=#{key}=#{value}"
    end
    last_command = [
      "docker", 
      "build", 
      "--file=#{dockerfile_path}", 
      "--tag=decidim:#{tag.docker_tag(version.decidim_version)}", 
      *docker_args,
      "./docker"
    ]
    begin
      Docker::Task.system!(
        *last_command
      )
    rescue => e
      Docker::Task.put("Error: Failed to build #{tag.docker_tag(version.decidim_version)}")
      Docker::Task.put("Error: #{e.message}")
      next "❌ ERROR: decidim:#{tag.docker_tag(version.decidim_version)}"
    end
    last_command = nil
    "✅ BUILT: decidim:#{tag.docker_tag(version.decidim_version)}"
  end
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
  Docker::Task.put("last command: #{last_command.join(" ")}") if last_command
end

##
# Push docker images to docker hub
# @param distribution_singleton [Docker::Redhat | Docker::Ubuntu]
# @param args [Hash]
# @param push_default [Boolean] If first version should be pushed without Distro name
# @return [void]
def push_docker_images(distribution_singleton, args, push_default: false)
  if ENV["DOCKER_HUB_REGISTRY"].nil?
    Docker::Task.put("DOCKER_HUB_REGISTRY is not set")
    Docker::Task.help
    exit 1
  end
  registry_username = ENV["DOCKER_HUB_REGISTRY"]

  messages = []
  distribution_singleton.versionned_tag_names.each_with_index do |tag, index|
    version = decidim_from_args(args)
    source_tag = tag.docker_tag(version.decidim_version)
    Docker::Task.put("Prepare #{version.decidim_version}")
    if index == 0 && push_default
      messages += version.version_aliases[1..].map do |dest_version|
        dest_version = "#{dest_version}"
        destination_tag = "#{registry_username}/decidim:#{dest_version}"
        begin
          Docker::Task.put("tagging #{destination_tag}")
          Docker::Task.system!("docker", "tag", "decidim:#{source_tag}", destination_tag)
          if ENV["DRY_RUN"] == "1"
            Docker::Task.put("DRY_RUN: docker push #{destination_tag}")
            Docker::Task.put("DRY_RUN: skip push")
          else
            Docker::Task.system!("docker", "push", destination_tag)
            Docker::Task.put("pushed #{destination_tag}")
          end
          "✅ PUSHED: #{destination_tag}"
        rescue => e
          "❌ ERROR: #{destination_tag} - #{e.message}"
        end
      end
    end
    # 0.29.2 will push tags for `0.29` and `0.29.2`
    messages += version.version_aliases[1..].map do |dest_version|
      dest_version = tag.docker_tag(dest_version)
      destination_tag = "#{registry_username}/decidim:#{dest_version}"
      Docker::Task.put("tagging #{destination_tag}")
      begin
        if ENV["DRY_RUN"] == "1"
          Docker::Task.put("DRY_RUN: docker tag decidim:#{source_tag} #{destination_tag}")
          Docker::Task.put("DRY_RUN: docker push #{destination_tag}")
        else
          Docker::Task.system!("docker", "tag", "decidim:#{source_tag}", destination_tag)
          Docker::Task.system!("docker", "push", destination_tag)
          Docker::Task.put("pushed #{destination_tag}")
        end
        "✅ PUSHED: #{destination_tag}"
      rescue => e
        "❌ ERROR: #{destination_tag} - #{e.message}"
      end
    end
  end
  messages
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:build:redhat", [:version] do |_, args|
  messages = build_docker_image(Docker::Redhat.instance, decidim_from_args(args), "docker/redhat/Dockerfile")
  print_results(messages)
end

task :"docker:push:redhat", [:version] do |_, args|
  messages = push_docker_images(Docker::Redhat.instance, args, push_default: false)
  print_results(messages)
  if messages.any? { |message| message.include?("ERROR:") }
    exit 1
  end
end

task :"docker:build:ubuntu", [:version] do |_, args|
  messages = build_docker_image(Docker::Ubuntu.instance, decidim_from_args(args), "docker/ubuntu/Dockerfile")
  print_results(messages)
end

task :"docker:push:ubuntu", [:version] do |_, args|
  messages = push_docker_images(Docker::Ubuntu.instance, args, push_default: true)
  print_results(messages)
  if messages.any? { |message| message.include?("ERROR:") }
    exit 1
  end
end

task :"docker:clean", [] do
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:docs", [] do 
  versions = Decidim::Decidim.instance.versions
  template_vars = {
    github_repository: ENV.fetch("GITHUB_REPOSITORY", "decidim/docker"),
    github_ref_name: ENV.fetch("GITHUB_REF_NAME", "master"),
    develop_version: versions[0],
    last_version: versions[1],
    prev_version: versions[2],
    legacy_version: versions[3],
    ubuntu: Docker::Ubuntu.instance,
    redhat: Docker::Redhat.instance,
    registry_username: ENV.fetch("DOCKER_HUB_REGISTRY", "decidim"),
  }
  # Foreach templates/**/* files, read the file, replace the variables and write the result
  Dir.glob(File.join(__dir__, "templates", "**", "*.erb")).each do |file|
    template = File.read(file)
    destination = file.gsub("templates", ".").gsub(".erb", "")
    FileUtils.mkdir_p(File.dirname(destination))
    File.write(destination, ERB.new(template).result_with_hash(template_vars))
    Docker::Task.put("Generated #{destination}")
  rescue => e
    Docker::Task.put("Error: Failed to generate #{file}")
    raise e
  end
ensure
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end
