# DockerHubClient::V2Scim20UsersGet403Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **status** | **Object** |  | [optional] |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **detail** | **String** | Details about why the request failed. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20UsersGet403Response.new(
  status: 403,
  schemas: null,
  detail: null
)
```

