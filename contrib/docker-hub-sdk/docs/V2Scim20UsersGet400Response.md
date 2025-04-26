# DockerHubClient::V2Scim20UsersGet400Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **status** | **Object** |  | [optional] |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **detail** | **String** | Details about why the request failed. | [optional] |
| **scim_type** | **String** | Some types of errors will return this per the specification. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20UsersGet400Response.new(
  status: 400,
  schemas: null,
  detail: null,
  scim_type: null
)
```

