# DockerHubClient::ScimSchemaAttribute

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** |  | [optional] |
| **type** | **String** |  | [optional] |
| **multi_valued** | **Boolean** |  | [optional] |
| **description** | **String** |  | [optional] |
| **required** | **Boolean** |  | [optional] |
| **case_exact** | **Boolean** |  | [optional] |
| **mutability** | **String** |  | [optional] |
| **returned** | **String** |  | [optional] |
| **uniqueness** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimSchemaAttribute.new(
  name: userName,
  type: string,
  multi_valued: false,
  description: Unique identifier for the User, typically used by the user to directly authenticate to the service provider. Each User MUST include a non-empty userName value. This identifier MUST be unique across the service provider&#39;s entire set of Users.,
  required: true,
  case_exact: false,
  mutability: readWrite,
  returned: default,
  uniqueness: server
)
```

