# DockerHubClient::GetAuditLogsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **logs** | [**Array&lt;AuditLog&gt;**](AuditLog.md) | List of audit log events. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::GetAuditLogsResponse.new(
  logs: null
)
```

