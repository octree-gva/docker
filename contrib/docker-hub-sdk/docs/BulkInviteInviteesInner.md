# DockerHubClient::BulkInviteInviteesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **invitee** | **String** | invitee email or Docker ID | [optional] |
| **status** | **String** | status of the invite or validation error | [optional] |
| **invite** | [**Invite**](Invite.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::BulkInviteInviteesInner.new(
  invitee: null,
  status: null,
  invite: null
)
```

