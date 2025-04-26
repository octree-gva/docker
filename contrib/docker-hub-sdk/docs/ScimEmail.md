# DockerHubClient::ScimEmail

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **value** | **String** |  | [optional] |
| **display** | **String** |  | [optional] |
| **primary** | **Boolean** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimEmail.new(
  value: jon.snow@docker.com,
  display: jon.snow@docker.com,
  primary: true
)
```

