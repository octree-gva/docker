# DockerHubClient::OrgMemberPaginated

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **count** | **Float** | The total number of items that match with the search. | [optional] |
| **previous** | **String** | The URL or link for the previous page of items. | [optional] |
| **_next** | **String** | The URL or link for the next page of items. | [optional] |
| **results** | [**Array&lt;OrgMember&gt;**](OrgMember.md) | List of accounts. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::OrgMemberPaginated.new(
  count: 120,
  previous: https://hub.docker.com/v2/some/resources/items?page&#x3D;1&amp;page_size&#x3D;20,
  _next: https://hub.docker.com/v2/some/resources/items?page&#x3D;3&amp;page_size&#x3D;20,
  results: null
)
```

