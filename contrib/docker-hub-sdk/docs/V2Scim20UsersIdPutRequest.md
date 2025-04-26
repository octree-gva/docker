# DockerHubClient::V2Scim20UsersIdPutRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  |  |
| **name** | [**V2Scim20UsersIdPutRequestName**](V2Scim20UsersIdPutRequestName.md) |  | [optional] |
| **enabled** | **Boolean** | If this is omitted from the request, it will default to false resulting in a deactivated user. | [optional][default to false] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20UsersIdPutRequest.new(
  schemas: null,
  name: null,
  enabled: null
)
```

