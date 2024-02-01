require 'json'
require 'open-uri'
require 'rubygems'

# Represents a specific version of Decidim, including its dependencies like Ruby, Node, and Bundler versions.
class DecidimVersion
  attr_accessor :github_branch, :node_version, :ruby_version, :version, :commit_rev, :bundler_version

  # Initializes a new instance for a specific GitHub branch of Decidim.
  # @param [String] github_branch the branch to fetch version information from.
  def initialize(github_branch)
    self.github_branch = github_branch
    fetch_version_details!
  end

  # Converts the version information to a JSON string.
  # @return [String] JSON representation of the version information.
  def to_json(*args)
    {
      github_branch: github_branch,
      node_version: node_version,
      ruby_version: ruby_version,
      commit_rev: commit_rev,
      version: version,
      bundler_version: bundler_version
    }.to_json(*args)
  end

  private

  # Fetches and sets version details from various sources (GitHub, RubyGems).
  def fetch_version_details!
    self.commit_rev = fetch_git_commit_rev
    self.node_version = fetch_node_version
    self.ruby_version = fetch_ruby_version
    self.version = fetch_decidim_version
    self.bundler_version = fetch_bundler_version
  end

  # Fetches the latest git commit revision for the specified branch.
  # @return [String] the commit revision hash.
  def fetch_git_commit_rev
    `git log -1 \"#{github_branch}\" --pretty=format:\"%H\"`
  end

  # Fetches the Node.js version specified in the `package.json` of the GitHub repo.
  # @return [Array<String>] the Node.js version as [major, minor, patch].
  def fetch_node_version
    package_json = JSON.parse(URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/package.json").read)
    version_string = package_json['engines']['node'] || "16.20.0"
    version_string.scan(/\d+/)
  end

  # Fetches the Ruby version specified in the `.ruby-version` of the GitHub repo.
  # @return [Array<String>] the Ruby version as [major, minor, patch].
  def fetch_ruby_version
    version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/.ruby-version").read.gsub("ruby-", "").strip
    version_string.scan(/\d+/)
  end

  # Fetches the Decidim version by comparing the version specified in `version.rb` against RubyGems.
  # @return [Array<String>] the Decidim version as [major, minor, patch].
  def fetch_decidim_version
    version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/lib/decidim/version.rb").read.strip
    major, minor, patch = version_string.scan(/\d+/)
    fetch_matching_gem_version(major, minor, patch)
  end

  # Fetches the matching gem version from RubyGems based on major and minor version numbers.
  # @param [String] major the major version number.
  # @param [String] minor the minor version number.
  # @return [Array<String>] the matched version as [major, minor, patch].
  def fetch_matching_gem_version(major, minor, patch)
    url = "https://rubygems.org/api/v1/versions/decidim.json"
    gem_versions = JSON.parse(URI.open(url).read)
    gem_versions.each do |version_data|
      version = version_data['number']
      segments = Gem::Version.new(version).segments
      return segments if segments[0..1].join(".") == "#{major}.#{minor}"
    end
    [major, minor, patch] # Fallback if no matching version is found
  end

  # Fetches the Bundler version used, specified in the `Gemfile.lock` of the GitHub repo.
  # @return [Array<String>] the Bundler version as [major, minor, patch].
  def fetch_bundler_version
    gemfile_lock = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/Gemfile.lock").read.strip
    version_string = gemfile_lock.match(/^BUNDLED\s+WITH\s+(\d+\.\d+\.\d+)/)[1]
    version_string.scan(/\d+/)
  end
end
