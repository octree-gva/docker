# DockerHubClient::Users2FALoginRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **login_2fa_token** | **String** | The intermediate 2FA token returned from &#x60;/v2/users/login&#x60; API. |  |
| **code** | **String** | The Time-based One-Time Password of the Docker Hub account to authenticate with.  |  |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Users2FALoginRequest.new(
  login_2fa_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c,
  code: 123456
)
```

