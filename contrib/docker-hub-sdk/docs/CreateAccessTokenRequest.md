# DockerHubClient::CreateAccessTokenRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **token_label** | **String** | Friendly name for you to identify the token. |  |
| **scopes** | **Array&lt;String&gt;** | Valid scopes: \&quot;repo:admin\&quot;, \&quot;repo:write\&quot;, \&quot;repo:read\&quot;, \&quot;repo:public_read\&quot;  |  |
| **expires_at** | **Time** | Optional expiration date for the token. If omitted, the token will remain valid indefinitely.  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::CreateAccessTokenRequest.new(
  token_label: My read only token,
  scopes: [&quot;repo:read&quot;],
  expires_at: 2021-10-28T18:30:19.520861Z
)
```

