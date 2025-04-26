# DockerHubClient::OrgGroup

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **Float** | Group ID | [optional] |
| **uuid** | **String** | UUID for the group | [optional] |
| **name** | **String** | Name of the group | [optional] |
| **description** | **String** | Description of the group | [optional] |
| **member_count** | **Float** | Member count of the group | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::OrgGroup.new(
  id: 10,
  uuid: null,
  name: mygroup,
  description: Groups description,
  member_count: 10
)
```

