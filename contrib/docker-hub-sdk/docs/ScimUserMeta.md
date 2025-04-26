# DockerHubClient::ScimUserMeta

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **resource_type** | **String** |  | [optional] |
| **location** | **String** |  | [optional] |
| **created** | **Time** | The creation date for the user as a RFC3339 formatted string. | [optional] |
| **last_modified** | **Time** | The date the user was last modified as a RFC3339 formatted string. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimUserMeta.new(
  resource_type: User,
  location: https://hub.docker.com/v2/scim/2.0/Users/d80f7c79-7730-49d8-9a41-7c42fb622d9c,
  created: 2022-05-20T00:54:18Z,
  last_modified: 2022-05-20T00:54:18Z
)
```

