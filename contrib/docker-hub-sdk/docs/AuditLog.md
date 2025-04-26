# DockerHubClient::AuditLog

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **account** | **String** |  | [optional] |
| **action** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **actor** | **String** |  | [optional] |
| **data** | **Hash&lt;String, String&gt;** |  | [optional] |
| **timestamp** | **Time** |  | [optional] |
| **action_description** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::AuditLog.new(
  account: null,
  action: null,
  name: null,
  actor: null,
  data: null,
  timestamp: null,
  action_description: null
)
```

