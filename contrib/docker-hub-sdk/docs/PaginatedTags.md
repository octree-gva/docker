# DockerHubClient::PaginatedTags

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **count** | **Integer** | total number of results available across all pages | [optional] |
| **_next** | **String** | link to next page of results if any | [optional] |
| **previous** | **String** | link to previous page of results  if any | [optional] |
| **results** | [**Array&lt;Tag&gt;**](Tag.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::PaginatedTags.new(
  count: null,
  _next: null,
  previous: null,
  results: null
)
```

