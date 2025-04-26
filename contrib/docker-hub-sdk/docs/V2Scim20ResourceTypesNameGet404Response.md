# DockerHubClient::V2Scim20ResourceTypesNameGet404Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **status** | **Object** |  | [optional] |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **detail** | **String** | Details about why the request failed. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20ResourceTypesNameGet404Response.new(
  status: 404,
  schemas: null,
  detail: null
)
```

