require 'net/http'
require 'json'

##
# If we need to push to the remote registery
# or just dry-run these actions.
def push_to_registery?
    ["1", "true", "enable"].include?(ENV.fetch("REGISTERY_PUSH", "false"))
end

##
# iterate through semver element and trigger the given
# block for all the patch/minor tags.
# 
# Example:
# tag_version("0.27.9") {|version| puts version}
# # 0.27.9
# # 0.27
#
def tag_versions(decidim_versions)
    prev_version = decidim_versions.first
    decidim_versions[1..].each do |version_seg| 
        prev_version = "#{prev_version}.#{version_seg}"
        yield(prev_version)
    end
end

