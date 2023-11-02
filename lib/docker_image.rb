# Find the right debian:buster image for each Decidim Version 
require_relative 'ruby_buster_repo'
require 'forwardable'

class DockerImage
    extend Forwardable

    attr_accessor :decidim_version, :slim_buster_tag
    def_delegators :@decidim_version, 
        :github_branch, :node_version, 
        :ruby_version, :version, 
        :commit_rev, :version, 
        :bundler_version

    def initialize(decidim_version)
        @decidim_version = decidim_version
        find_ruby_slim_buster_tag!
    end
    
    def to_json(*args)
        {
          slim_buster_tag: slim_buster_tag,
          **@decidim_version.to_json(*args),
        }.to_json(*args)
      end

    private
    ##
    # Reading decidim repo we have our desired ruby version (@decidim_version).
    # From this, we get all the ruby:slim_buster images and try to find the best match,
    # looking at the major/minor version and trying to get the highest patch version.
    def find_ruby_slim_buster_tag!
        self.slim_buster_tag = RubyBusterRepo.versions.find do |buster_t, ruby|
            r_major, r_minor, r_patch = ruby
            t_major, t_minor, t_patch = @decidim_version.ruby_version
            r_major == t_major && r_minor == t_minor
        end.first
    end
end
