# DockerHubClient::AuthCreateAccessTokenRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **identifier** | **String** | The identifier of the account to create an access token for. If using a password or personal access token, this must be a username. If using an organization access token, this must be an organization name.  |  |
| **secret** | **String** | The secret of the account to create an access token for. This can be a password, personal access token, or organization access token.  |  |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::AuthCreateAccessTokenRequest.new(
  identifier: myusername,
  secret: dckr_pat_124509ugsdjga93
)
```

