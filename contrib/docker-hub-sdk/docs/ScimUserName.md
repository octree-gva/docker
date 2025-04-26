# DockerHubClient::ScimUserName

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **given_name** | **String** |  | [optional] |
| **family_name** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimUserName.new(
  given_name: Jon,
  family_name: Snow
)
```

