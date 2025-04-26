# DockerHubClient::GetAuditActionsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **actions** | [**Hash&lt;String, AuditLogActions&gt;**](AuditLogActions.md) | Map of audit log actions. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::GetAuditActionsResponse.new(
  actions: null
)
```

