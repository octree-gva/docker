# DockerHubClient::AccessToken

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **uuid** | **String** |  | [optional] |
| **client_id** | **String** |  | [optional] |
| **creator_ip** | **String** |  | [optional] |
| **creator_ua** | **String** |  | [optional] |
| **created_at** | **String** |  | [optional] |
| **last_used** | **String** |  | [optional] |
| **generated_by** | **String** |  | [optional] |
| **is_active** | **Boolean** |  | [optional] |
| **token** | **String** |  | [optional] |
| **token_label** | **String** |  | [optional] |
| **scopes** | **Array&lt;String&gt;** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::AccessToken.new(
  uuid: b30bbf97-506c-4ecd-aabc-842f3cb484fb,
  client_id: HUB,
  creator_ip: 127.0.0.1,
  creator_ua: some user agent,
  created_at: 2021-07-20T12:00:00.000000Z,
  last_used: null,
  generated_by: manual,
  is_active: true,
  token: a7a5ef25-8889-43a0-8cc7-f2a94268e861,
  token_label: My read only token,
  scopes: [&quot;repo:read&quot;]
)
```

