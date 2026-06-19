require 'dotenv/load'
require 'erb'
require 'active_support/core_ext/string'
require_relative './lib/docker'
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
  non_nil_messages = messages.reject { |message| message.nil? }
  return if non_nil_messages.empty?
  Docker::Task.put("*" * 80)
  Docker::Task.put("Results:")
  non_nil_messages.each do |message|
    Docker::Task.put("* #{message}")
  end
  Docker::Task.put("*" * 80)
end

def fail_on_build_results!(messages)
  built = messages.count { |m| m&.start_with?("✅ BUILT:") }
  if built.zero?
    Docker::Task.put("Error: no images were built")
    exit 1
  end
  exit 1 if messages.any? { |m| m&.include?("ERROR:") }
end

def os_tag_for(distribution, os_name)
  distribution = distribution.to_sym if distribution.is_a?(String)
  tags = distribution == :ubuntu ? Docker::OsMatrix.instance.ubuntu_tags : Docker::OsMatrix.instance.redhat_tags
  tag = tags.find { |t| t.os_name == os_name }
  raise "Unknown OS name #{os_name} for #{distribution}" unless tag

  tag
end
#
##
# Build docker images
# @param distribution_singleton [Docker::Redhat | Docker::Ubuntu]
# @param version [Decidim::DecidimVersion]
# @return [void]
def docker_build_command(dockerfile_path, tag_name, docker_args)
  docker_arg_flags = docker_args.map { |key, value| "--build-arg=#{key}=#{value}" }
  command = [
    "docker",
    "build",
    "--file=#{dockerfile_path}",
    "--tag=decidim:#{tag_name}",
    *docker_arg_flags,
    "./docker"
  ]
  if ENV["BUILDX_CACHE"] == "1"
    command = [
      "docker", "buildx", "build",
      "--cache-from", "type=gha",
      "--cache-to", "type=gha,mode=max",
      "--load",
      "--file=#{dockerfile_path}",
      "--tag=decidim:#{tag_name}",
      *docker_arg_flags,
      "./docker"
    ]
  end
  command
end

def build_docker_image_tag(tag, version, dockerfile_path)
  docker_args = {
    OS_VERSION: tag.os_version,
    OS_NAME: tag.os_name,
    OS_MAJOR_VERSION: tag.os_major_version,
  }.merge(version.docker_args)
  tag_name = tag.docker_tag(version.decidim_version)
  command = docker_build_command(dockerfile_path, tag_name, docker_args)
  Docker::Task.system!(*command)
  "✅ BUILT: decidim:#{tag_name}"
rescue => e
  Docker::Task.put("Error: Failed to build decidim:#{tag_name}")
  Docker::Task.put("Error: #{e.message}")
  "❌ ERROR: decidim:#{tag_name}"
end

def build_docker_image(distribution_singleton, version, dockerfile_path)
  last_command = nil
  distribution_singleton.pinned_tags.map do |tag|
    tag_name = tag.docker_tag(version.decidim_version)
    last_command = docker_build_command(
      dockerfile_path,
      tag_name,
      {
        OS_VERSION: tag.os_version,
        OS_NAME: tag.os_name,
        OS_MAJOR_VERSION: tag.os_major_version,
      }.merge(version.docker_args)
    )
    begin
      Docker::Task.system!(*last_command)
    rescue => e
      Docker::Task.put("Error: Failed to build #{tag_name}")
      Docker::Task.put("Error: #{e.message}")
      next "❌ ERROR: decidim:#{tag_name}"
    end
    last_command = nil
    "✅ BUILT: decidim:#{tag_name}"
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
# @param push_default [Boolean] If first version should be pushed without Distro name. if "dev" version, also push latest tag.
# @return [void]
def push_docker_images(distribution_singleton, args, push_default: false)
  push_docker_images_for_tags(
    distribution_singleton,
    args,
    distribution_singleton.pinned_tags,
    push_default: push_default
  )
end

def push_docker_images_for_tags(_distribution_singleton, args, tags, push_default: false)
  if ENV["DOCKER_HUB_REGISTRY"].nil?
    Docker::Task.put("DOCKER_HUB_REGISTRY is not set")
    Docker::Task.help
    exit 1
  end
  registry_username = ENV["DOCKER_HUB_REGISTRY"]

  messages = []
  version = decidim_from_args(args)
  tags.each_with_index do |tag, index|
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

          # push latest tag
          if args[:version] == "dev" 
            destination_tag = "#{registry_username}/decidim:latest"
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
          end
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
  fail_on_build_results!(messages)
end

task :"docker:build:ubuntu_one", %i[version os_name] do |_, args|
  version = decidim_from_args(args)
  tag = os_tag_for(:ubuntu, args[:os_name])
  messages = [build_docker_image_tag(tag, version, "docker/ubuntu/Dockerfile")]
  print_results(messages)
  fail_on_build_results!(messages)
ensure
  Decidim::Decidim.instance.clean_clone
end

task :"docker:build:redhat_one", %i[version os_name] do |_, args|
  version = decidim_from_args(args)
  tag = os_tag_for(:redhat, args[:os_name])
  messages = [build_docker_image_tag(tag, version, "docker/redhat/Dockerfile")]
  print_results(messages)
  fail_on_build_results!(messages)
ensure
  Decidim::Decidim.instance.clean_clone
end

task :"docker:push:redhat", [:version] do |_, args|
  Docker::DockerHub.configure!
  messages = push_docker_images(Docker::Redhat.instance, args, push_default: false)
  print_results(messages)
  if messages.any? { |message| message&.include?("ERROR:") }
    exit 1
  end
end

task :"docker:build:ubuntu", [:version] do |_, args|
  messages = build_docker_image(Docker::Ubuntu.instance, decidim_from_args(args), "docker/ubuntu/Dockerfile")
  print_results(messages)
  fail_on_build_results!(messages)
end

task :"docker:push:ubuntu_one", %i[version os_name] do |_, args|
  Docker::DockerHub.configure!
  tag = os_tag_for(:ubuntu, args[:os_name])
  push_default = ENV["PUSH_VERSION_ALIASES"] == "1"
  messages = push_docker_images_for_tags(Docker::Ubuntu.instance, args, [tag], push_default: push_default)
  print_results(messages)
  exit 1 if messages.any? { |message| message&.include?("ERROR:") }
end

task :"docker:push:redhat_one", %i[version os_name] do |_, args|
  Docker::DockerHub.configure!
  tag = os_tag_for(:redhat, args[:os_name])
  messages = push_docker_images_for_tags(Docker::Redhat.instance, args, [tag], push_default: false)
  print_results(messages)
  exit 1 if messages.any? { |message| message&.include?("ERROR:") }
end

task :"docker:push:ubuntu", [:version] do |_, args|
  Docker::DockerHub.configure!
  messages = push_docker_images(Docker::Ubuntu.instance, args, push_default: true)
  print_results(messages)
  if messages.any? { |message| message&.include?("ERROR:") }
    exit 1
  end
end

task :"docker:clean", [] do
  Decidim::Decidim.instance.clean_clone
  Docker::Task.put("decidim-clone directory removed")
end

task :"docker:image_ref", %i[distribution version os_name] do |_, args|
  version = decidim_from_args(args)
  distribution = args[:distribution].to_sym
  tag = os_tag_for(distribution, args[:os_name])
  puts "decidim:#{tag.docker_tag(version.decidim_version)}"
ensure
  Decidim::Decidim.instance.clean_clone
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
