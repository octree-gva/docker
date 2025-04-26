# DockerHubClient::V2OrgsOrgNameGroupsGroupNameMembersGet200Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **count** | **Float** |  | [optional] |
| **_next** | **String** |  | [optional] |
| **previous** | **String** |  | [optional] |
| **results** | [**Array&lt;GroupMember&gt;**](GroupMember.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2OrgsOrgNameGroupsGroupNameMembersGet200Response.new(
  count: 1,
  _next: null,
  previous: null,
  results: null
)
```

