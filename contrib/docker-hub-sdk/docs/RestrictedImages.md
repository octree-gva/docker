# DockerHubClient::RestrictedImages

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **enabled** | **Boolean** | Whether or not to restrict image usage for users in the organization. | [optional] |
| **allow_official_images** | **Boolean** | Allow usage of official images if \&quot;enabled\&quot; is &#x60;true&#x60;. | [optional] |
| **allow_verified_publishers** | **Boolean** | Allow usage of verified publisher images if \&quot;enabled\&quot; is &#x60;true&#x60;. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::RestrictedImages.new(
  enabled: true,
  allow_official_images: true,
  allow_verified_publishers: true
)
```

