require_relative 'ruby_repo'
require 'forwardable'

# Represents a Docker image specifically tailored for a Decidim version, finding the most appropriate debian:buster image.
class DockerImage
  extend Forwardable

  attr_accessor :decidim_version, :ruby_tag

  # Delegates certain methods to the @decidim_version instance to avoid direct attribute access.
  def_delegators :@decidim_version, 
    :github_branch, :node_version,
    :ruby_version, :version, 
    :commit_rev, :bundler_version

  # Initializes a new DockerImage object with a DecidimVersion instance.
  # @param decidim_version [DecidimVersion] the Decidim version information.
  def initialize(decidim_version)
    @decidim_version = decidim_version
    self.ruby_tag = match_ruby_ruby_tag
  end

  # Converts the Docker image and associated Decidim version information to JSON.
  # @return [String] JSON representation of the Docker image and Decidim version information.
  def to_json(*args)
    {
      ruby_tag: self.ruby_tag,
      **JSON.parse(@decidim_version.to_json(*args))
    }.to_json(*args)
  end

  private

  # Matches the best Ruby version fit for Decidim version against the available ruby:slim-<debian release> Docker images.
  # This method finds the ruby image with the closest matching Ruby version, prioritizing the patch version.
  def match_ruby_ruby_tag
    desired_ruby_version = @decidim_version.ruby_version
    match = RubyRepo.versions.find do |buster_tag, ruby_version|
      major_match, minor_match = match_major_minor_version?(desired_ruby_version, ruby_version)
      major_match && minor_match
    end.first
    # major+minor does not match, fallback to major match: 
    match = RubyRepo.versions.find do |buster_tag, ruby_version|
      major_match, minor_match = match_major_minor_version?(desired_ruby_version, ruby_version)
      major_match
    end.first unless match

    raise "Can not find ruby tag for decidim #{decidim_version}. Looking for: #{desired_ruby_version} in #{RubyRepo.versions.join(" ")}" unless match
    match
  end

  # Checks if the major numbers match between the desired Ruby version and a candidate version.
  # @param desired [Array<String>] the desired Ruby version as [major, minor, patch].
  # @param candidate [Array<String>] the candidate Ruby version as [major, minor, patch].
  # @return [Array<Boolean>] [major_match, minor_match ]
  def match_major_minor_version?(desired, candidate)
    desired_major, desired_minor, _ = desired
    candidate_major, candidate_minor, _ = candidate
    [
      desired_major == candidate_major,
      desired_minor == candidate_minor
  ]
  end
end
