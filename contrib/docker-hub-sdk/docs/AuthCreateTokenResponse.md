# DockerHubClient::AuthCreateTokenResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **access_token** | **String** | The created access token. This expires in 10 minutes. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::AuthCreateTokenResponse.new(
  access_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
)
```

