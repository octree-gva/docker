require 'net/http'
require 'json'

def push_to_registery?
    ["1", "true", "enable"].include?(ENV.fetch("REGISTERY_PUSH", "false"))
end


def tag_versions(decidim_versions)
    prev_version = decidim_versions.first
    decidim_versions[1..].each do |version_seg| 
        prev_version = "#{prev_version}.#{version_seg}"
        yield(prev_version)
    end
end

