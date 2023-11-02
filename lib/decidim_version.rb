

require 'json'
require 'open3'
require 'open-uri'
require 'rubygems'

class DecidimVersion
    attr_accessor :github_branch, :node_version, :ruby_version, :version, :commit_rev, :version, :bundler_version
    def initialize(github_branch)
        self.github_branch = github_branch
        parse_metadatas!
    end

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

    ##
    # Get all the information needed for a given decidim version.
    def parse_metadatas!
        self.commit_rev = `git log -1 \"#{github_branch}\" --pretty=format:\"%H\"`
        self.node_version = read_node_version
        self.ruby_version = read_ruby_version
        self.version = read_decidim_version
        self.bundler_version = read_bundler_version
    end
    ##
    # Fetch the package.json in the remote github repo. 
    # Identifies the node version and returns an array representing 
    # the semver version: [major, minor, patch]. 
    def read_node_version
        package_json = JSON.parse(URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/package.json").read)
        version_string = package_json['engines']['node'] || "16.20.0"   
        major, minor, patch = version_string.scan(/\d+/) 
    end
    ##
    # Fetch the .ruby-version in the remote github repo. 
    # Identifies the ruby version and returns an array representing 
    # the semver version: [major, minor, patch]. 
    def read_ruby_version
        version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/.ruby-version").read.gsub("ruby-", "").strip
        major, minor, patch = version_string.scan(/\d+/)
    end
    ##
    # Fetch the version.rb in the remote github repo. 
    # Identifies the Decidim version and compares it to the ones available
    # in RubyGem. 
    # The best match beween wanted version (version.rb) and the available (RubyGem)
    # is returned in a an array representing semver version: [major, minor, patch]. 
    def read_decidim_version
        version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/lib/decidim/version.rb").read.strip
        major, minor, patch = version_string.scan(/\d+/)
        # The version in the code might NOT be the last published version. 
        # The process is: merge in branch, publish the gem => while release is processing, 
        # the version will be wrong. 
        # We fix that looking for the last patch released for the version in the source code. 
        url = "https://rubygems.org/api/v1/versions/decidim.json"
        gem_versions = JSON.parse(URI.open(url).read)
        gem_versions.each do |version_data|
          version = version_data['number']
          segments = Gem::Version.new(version).segments
          if segments[0..1].join(".") == "#{major}.#{minor}"
            return segments
          end
        end
        return [major, minor, patch]
    end
    ##
    # Read the remote Gemfile.lock to identifies the bundler version
    # used. 
    # Return an array representing semver version: [major, minor, patch]. 
    def read_bundler_version
        gemfile_lock = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/Gemfile.lock").read.strip
        version_string = gemfile_lock.match(/^BUNDLED\s+WITH\s+(\d+\.\d+\.\d+)/)[1]
        major, minor, patch = version_string.scan(/\d+/)
    end
end