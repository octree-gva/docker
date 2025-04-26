# DockerHubClient::ScimSchema

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **id** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **attributes** | [**Array&lt;ScimSchemaParentAttribute&gt;**](ScimSchemaParentAttribute.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimSchema.new(
  schemas: [&quot;urn:ietf:params:scim:schemas:core:2.0:Schema&quot;],
  id: urn:ietf:params:scim:schemas:core:2.0:User,
  name: User,
  description: User Account,
  attributes: []
)
```

