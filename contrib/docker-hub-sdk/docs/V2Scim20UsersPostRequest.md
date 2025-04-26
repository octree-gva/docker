# DockerHubClient::V2Scim20UsersPostRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  |  |
| **user_name** | **String** | The user&#39;s email address. This must be reachable via email. |  |
| **name** | [**ScimUserName**](ScimUserName.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2Scim20UsersPostRequest.new(
  schemas: null,
  user_name: jon.snow@docker.com,
  name: null
)
```

