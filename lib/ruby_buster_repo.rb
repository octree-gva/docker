require 'json'
require 'open3'
require 'open-uri'
class RubyBusterRepo
    def self.versions
        @versions ||= self.parse_versions
    end

    def self.parse_versions
        versions = {}
        page = 1
        loop do
            url = "https://hub.docker.com/v2/namespaces/library/repositories/ruby/tags?page=#{page}&page_size=100"
            response = JSON.parse(URI.open(url).read)
            tags = response['results']
            break if tags.empty? || page > 5
            selected_tags = tags.select { |tag| tag['name'].include?('slim-buster') && !tag["name"].include?('preview') }
            selected_tags.each do |tag|
                major, minor, patch = tag['name'].scan(/\d+/)
                versions[tag["name"]] = [major, minor || "0", patch || "0"]
            end
            page += 1
        end
        versions.sort_by { |tag, ruby_version| ruby_version.join(".") }.sort
    end
end
