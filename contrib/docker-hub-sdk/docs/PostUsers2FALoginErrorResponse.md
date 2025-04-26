# DockerHubClient::PostUsers2FALoginErrorResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **detail** | **String** | Description of the error. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::PostUsers2FALoginErrorResponse.new(
  detail: Incorrect authentication credentials
)
```

