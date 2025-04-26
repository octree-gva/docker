# DockerHubClient::AuditLogActions

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **actions** | [**Array&lt;AuditLogAction&gt;**](AuditLogAction.md) | List of audit log actions. | [optional] |
| **label** | **String** | Grouping label for a particular set of audit log actions. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::AuditLogActions.new(
  actions: null,
  label: null
)
```

