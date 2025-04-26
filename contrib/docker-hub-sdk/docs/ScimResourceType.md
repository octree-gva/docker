# DockerHubClient::ScimResourceType

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **id** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **endpoint** | **String** |  | [optional] |
| **schema** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimResourceType.new(
  schemas: [&quot;urn:ietf:params:scim:schemas:core:2.0:ResourceType&quot;],
  id: User,
  name: User,
  description: User,
  endpoint: /Users,
  schema: urn:ietf:params:scim:schemas:core:2.0:User
)
```

