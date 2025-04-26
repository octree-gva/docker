# DockerHubClient::V2Scim20ServiceProviderConfigGet401Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **status** | **Object** |  | [optional] |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **detail** | **String** | Details about why the request failed. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20ServiceProviderConfigGet401Response.new(
  status: 401,
  schemas: null,
  detail: null
)
```

