# DockerHubClient::CreateOrgAccessTokenRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **label** | **String** | Label for the access token | [optional] |
| **description** | **String** | Description of the access token | [optional] |
| **resources** | [**Array&lt;OrgAccessTokenResource&gt;**](OrgAccessTokenResource.md) | Resources this token has access to | [optional] |
| **expires_at** | **Time** | Expiration date for the token | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::CreateOrgAccessTokenRequest.new(
  label: My organization token,
  description: Token for CI/CD pipeline,
  resources: null,
  expires_at: 2023-05-20T00:54:18Z
)
```

