# DockerHubClient::V2Scim20UsersGet200Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **total_results** | **Integer** |  | [optional] |
| **start_index** | **Integer** |  | [optional] |
| **items_per_page** | **Integer** |  | [optional] |
| **resources** | [**Array&lt;ScimUser&gt;**](ScimUser.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20UsersGet200Response.new(
  schemas: [&quot;urn:ietf:params:scim:api:messages:2.0:ListResponse&quot;],
  total_results: 1,
  start_index: 1,
  items_per_page: 10,
  resources: null
)
```

