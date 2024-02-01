require 'json'
require 'open3'
require 'open-uri'
class RubyRepo
    def self.versions
        @versions ||= self.parse_versions
    end
    def self.docker_token
        token_url = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ruby:pull"
        uri = URI.parse(token_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth(ENV.fetch("REGISTRY_USERNAME"), ENV.fetch("DOCKERHUB_TOKEN"))
        response = http.request(req)
        JSON.parse(response.body)["token"]
    end
    def self.parse_versions
        versions = {}
        page = 1
        loop do
            url = "https://hub.docker.com/v2/namespaces/library/repositories/ruby/tags?page=#{page}&page_size=100"
            response = JSON.parse(URI.open(url).read)
            tags = response['results']
            break if tags.empty? || page > 5
            selected_tags = tags.select { |tag| tag["tag_status"] == "active" && tag['name'].include?("slim-") && !tag["name"].include?('preview') }
            selected_tags.each do |tag|
                major, minor, patch = tag['name'].scan(/\d+/)
                versions[tag["name"]] = [major, minor || "0", patch || "0"] if major
            end
            page += 1
        end
        versions.sort_by do |tag, ruby_version| 
            [
                ruby_version.join(".") + (tag.include?(ENV.fetch("DEBIAN_RELEASE", "bookworm")) ? "-1" : "-0")
            ]
        end.reverse
    end
end
