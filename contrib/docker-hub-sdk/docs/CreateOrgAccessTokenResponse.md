# DockerHubClient::CreateOrgAccessTokenResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  | [optional] |
| **label** | **String** |  | [optional] |
| **created_by** | **String** |  | [optional] |
| **is_active** | **Boolean** |  | [optional] |
| **created_at** | **Time** |  | [optional] |
| **expires_at** | **Time** |  | [optional] |
| **last_used_at** | **Time** |  | [optional] |
| **token** | **String** | The actual token value that can be used for authentication | [optional] |
| **resources** | [**Array&lt;OrgAccessTokenResource&gt;**](OrgAccessTokenResource.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::CreateOrgAccessTokenResponse.new(
  id: a7a5ef25-8889-43a0-8cc7-f2a94268e861,
  label: My organization token,
  created_by: johndoe,
  is_active: true,
  created_at: 2022-05-20T00:54:18Z,
  expires_at: 2023-05-20T00:54:18Z,
  last_used_at: 2022-06-15T12:30:45Z,
  token: dckr_oat_7awgM4jG5SQvxcvmNzhKj8PQjxo,
  resources: null
)
```

