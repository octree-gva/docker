# DockerHubClient::GetOrgAccessTokensResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **total** | **Float** |  | [optional] |
| **_next** | **String** |  | [optional] |
| **previous** | **String** |  | [optional] |
| **results** | [**Array&lt;OrgAccessToken&gt;**](OrgAccessToken.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::GetOrgAccessTokensResponse.new(
  total: 10,
  _next: https://hub.docker.com/v2/orgs/docker/access-tokens?page&#x3D;2&amp;page_size&#x3D;10,
  previous: https://hub.docker.com/v2/orgs/docker/access-tokens?page&#x3D;1&amp;page_size&#x3D;10,
  results: null
)
```

