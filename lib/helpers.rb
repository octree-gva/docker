require 'net/http'
require 'json'

# Checks if operations should push changes to the remote registry or perform a dry-run.
# The decision is based on the environment variable `REGISTRY_PUSH`.
#
# @return [Boolean] true if the environment variable indicates that pushing is enabled; false otherwise.
def push_to_registry?
  # Corrected spelling from "registry" to "registry"
  ["1", "true", "enable"].include?(ENV.fetch("REGISTRY_PUSH", "false"))
end

# Iterates through semantic versioning elements of a Decidim version and yields
# each significant version tag to the given block. This includes both the specific
# version and its more general form (major.minor).
#
# @param decidim_versions [Array<String>] an array of version segments (major, minor, patch).
# @yield [String] yields each significant version string to the block.
# @example
#   tag_versions(["0", "27", "9"]) { |version| puts version }
#   # Outputs:
#   # 0.27.9
#   # 0.27
def tag_versions(decidim_versions)
  # Initialize a variable to hold the major version segment
  prev_version = decidim_versions.first

  # Iterate over the version segments starting from the minor version element
  decidim_versions[1..].each do |version_seg|
    prev_version = "#{prev_version}.#{version_seg}"  # Concatenate the version segments
    yield(prev_version)  # Yield the concatenated version string to the block
  end
end


##
# Build docker images related to metadatas (version, compatible debian and node versions, etc.)
def build_images(docker_image, remote_image)
    decidim_version_string = docker_image.version.join(".")
    decidim_major_minor_version_string = docker_image.version[0..1].join(".")
    build_date = Time.now.utc.strftime("%Y-%m-%dT%H:%MZ")
    is_stable = docker_image.github_branch.include?("stable")
    source_tag = "decidim:#{is_stable ? decidim_version_string : "nightly"}"
    node_major_version = docker_image.node_version[0]
    bundler_version = docker_image.bundler_version.join(".")

    generator_params = if is_stable 
        [
            "--build-arg", "GENERATOR_GEMINSTALL='#{decidim_version_string}'"
        ]
    else
        [
            "--build-arg", "GENERATOR_GEMINSTALL=git: 'https://github.com/decidim/decidim', branch: '#{docker_image.github_branch}'",
            "--build-arg",  "GENERATOR_PARAMS=--branch=develop"
        ]
    end
    docker_build_args = [        
        *generator_params,
        "--build-arg", "DECIDIM_VERSION=#{decidim_version_string}",
        "--build-arg", "DECIDIM_MAJOR_MINOR_VERSION=#{decidim_major_minor_version_string}",
        "--build-arg", "BASE_IMAGE=ruby:#{docker_image.ruby_tag}",
        "--build-arg", "VERSION=#{decidim_version_string}",
        "--build-arg", "BUNDLER_VERSION=#{bundler_version}",
        "--build-arg", "NODE_MAJOR_VERSION=#{node_major_version}",
        "--build-arg", "BUILD_DATE=#{build_date}",
        "--build-arg", "VCS_REF=#{docker_image.commit_rev}",
        "--build-arg", "GROUP_ID=1001",
        "--build-arg", "USER_ID=1001",
        "--build-arg", "BUILDKIT_INLINE_CACHE=1",
        "--network=host",
        "-f", "./Dockerfile", "./bundle"
    ]
    # Tags we want to make, [<docker tag>, <docker stage target>]
    tags = [
        ["-dev", "decidim-development"],
        ["-onbuild", "decidim-production-onbuild"],
        ["", "decidim-production"],
    ]
    tags.each do |docker_tag_suffix, docker_target|
        cache_from = "#{remote_image}:#{is_stable ? decidim_version_string : "nightly"}#{docker_tag_suffix}"
        system("docker", "pull", cache_from)
        docker_cmd = [
            "docker", "buildx", "build",
            "--cache-from", "type=registry,ref=#{cache_from}",
            "--tag", "#{source_tag}#{docker_tag_suffix}",
            "--target", docker_target,
            *docker_build_args
        ];
        puts docker_cmd.join(" ")
        raise "docker failed to build #{decidim_version_string}-dist image. command: #{docker_cmd.join(" ")}" unless system(*docker_cmd)
    end
end

##
# Docker tag an image name to a destination image name, and push the latter.
def push_image(source, destination)
    tag_image(source, destination)
    push_command = ["docker", "push", "#{destination}"]
    if push_to_registry?
        raise "docker failed to push #{destination}. command: #{push_command.join(" ")}" unless system(*push_command)
    else
        puts "--dry-run: #{push_command.join(" ")}"
    end
end

##
# Remove given docker images with `docker rmi`
def remove_images(tags)
    remove_images_command = ["docker", "rmi", *tags]
    raise "docker failed to remove #{tags.join(" ")}. command: #{remove_images_command.join(" ")}" unless system(*remove_images_command)
end

##
# Docker tag an image name to a new image name
def tag_image(source, destination)
    tag_command = ["docker", "tag", "#{source}", "#{destination}"]
    if push_to_registry?
        raise "docker failed to tag #{destination}. command: #{tag_command.join(" ")}" unless system(*tag_command)
    else
        puts "--dry-run: #{tag_command.join(" ")}"
    end
end