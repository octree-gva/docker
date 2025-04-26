# DockerHubClient::GetAccessTokensResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **count** | **Float** |  | [optional] |
| **_next** | **String** |  | [optional] |
| **previous** | **String** |  | [optional] |
| **active_count** | **Float** |  | [optional] |
| **results** | [**Array&lt;V2AccessTokensUuidGet200Response&gt;**](V2AccessTokensUuidGet200Response.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::GetAccessTokensResponse.new(
  count: 1,
  _next: null,
  previous: null,
  active_count: 1,
  results: null
)
```

