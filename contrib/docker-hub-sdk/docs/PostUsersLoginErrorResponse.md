# DockerHubClient::PostUsersLoginErrorResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **detail** | **String** | Description of the error. |  |
| **login_2fa_token** | **String** | Short time lived token to be used on &#x60;/v2/users/2fa-login&#x60; to complete the authentication. This field is present only if 2FA is enabled.  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::PostUsersLoginErrorResponse.new(
  detail: Incorrect authentication credentials,
  login_2fa_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
)
```

