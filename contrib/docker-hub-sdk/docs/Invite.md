# DockerHubClient::Invite

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | uuid representing the invite id | [optional] |
| **inviter_username** | **String** |  | [optional] |
| **invitee** | **String** | can either be a dockerID for registred users or an email for non-registred users | [optional] |
| **org** | **String** | name of the org to join | [optional] |
| **team** | **String** | name of the team (user group) to join | [optional] |
| **created_at** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Invite.new(
  id: e36eca69-4cc8-4f17-9845-ae8c2b832691,
  inviter_username: moby,
  invitee: invitee@docker.com,
  org: docker,
  team: owners,
  created_at: 2021-10-28T18:30:19.520861Z
)
```

