

require 'json'
require 'open3'
require 'open-uri'

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

    def parse_metadatas!
        self.commit_rev = `git log -1 \"#{github_branch}\" --pretty=format:\"%H\"`
        self.node_version = read_node_version
        self.ruby_version = read_ruby_version
        self.version = read_decidim_version
        self.bundler_version = read_bundler_version
    end

    def read_node_version
        package_json = JSON.parse(URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/package.json").read)
        version_string = package_json['engines']['node'] || "16.20.0"   
        major, minor, patch = version_string.scan(/\d+/) 
    end
    
    def read_ruby_version
        version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/.ruby-version").read.gsub("ruby-", "").strip
        major, minor, patch = version_string.scan(/\d+/)
    end
    
    def read_decidim_version
        version_string = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/lib/decidim/version.rb").read.strip
        major, minor, patch = version_string.scan(/\d+/)
    end
    
    def read_bundler_version
        gemfile_lock = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/Gemfile.lock").read.strip
        version_string = gemfile_lock.match(/^BUNDLED\s+WITH\s+(\d+\.\d+\.\d+)/)
        major, minor, patch = version_string.scan(/\d+/)
    end
end