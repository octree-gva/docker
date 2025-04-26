# DockerHubClient::OrgAccessToken

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

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::OrgAccessToken.new(
  id: a7a5ef25-8889-43a0-8cc7-f2a94268e861,
  label: My organization token,
  created_by: johndoe,
  is_active: true,
  created_at: 2022-05-20T00:54:18Z,
  expires_at: 2023-05-20T00:54:18Z,
  last_used_at: 2022-06-15T12:30:45Z
)
```

