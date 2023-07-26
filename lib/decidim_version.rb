

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
        # Check last match over rubygem
        # If we have a major.minor, then we take the last patch available
        # on rubygem, and not the one present in the source. 
        # FIXME: having a publishing flow should let all this too much
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
    
    def read_bundler_version
        gemfile_lock = URI.open("https://raw.githubusercontent.com/decidim/decidim/#{github_branch}/Gemfile.lock").read.strip
        version_string = gemfile_lock.match(/^BUNDLED\s+WITH\s+(\d+\.\d+\.\d+)/)[1]
        major, minor, patch = version_string.scan(/\d+/)
    end
end