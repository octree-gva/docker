# DockerHubClient::UpdateOrgAccessTokenRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **label** | **String** | Label for the access token | [optional] |
| **description** | **String** | Description of the access token | [optional] |
| **resources** | [**Array&lt;OrgAccessTokenResource&gt;**](OrgAccessTokenResource.md) | Resources this token has access to | [optional] |
| **is_active** | **Boolean** | Whether the token is active | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::UpdateOrgAccessTokenRequest.new(
  label: My organization token,
  description: Token for CI/CD pipeline,
  resources: null,
  is_active: true
)
```

