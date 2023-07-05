# Find the right debian:buster image for each Decidim Version 
require_relative 'ruby_buster_repo'

class DockerImage
    attr_accessor :decidim_version, :buster_tag, :slim_buster_tag
    def initialize(decidim_version)
        self.decidim_version = decidim_version
        parse_metadatas!
    end
    def to_json(*args)
        {
          buster_tag: buster_tag,
          slim_buster_tag: slim_buster_tag,
          decidim_version: decidim_version,
        }.to_json(*args)
      end

    private
    def parse_metadatas!
        self.slim_buster_tag = RubyBusterRepo.versions.find do |buster_t, ruby|
            r_major, r_minor, r_patch = ruby
            t_major, t_minor, t_patch = decidim_version.ruby_version
            r_major == t_major && r_minor == t_minor
        end.first
        self.buster_tag = self.slim_buster_tag.gsub("slim-", "")
    end
end
