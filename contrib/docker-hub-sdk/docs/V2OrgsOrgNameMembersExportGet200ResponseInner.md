# DockerHubClient::V2OrgsOrgNameMembersExportGet200ResponseInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | First and last name of the member |  |
| **username** | **String** | Username of the member |  |
| **email** | **String** | Email address of the member |  |
| **type** | **String** | Type of the member |  |
| **permission** | **String** | Permission of the member | [optional] |
| **teams** | **String** | Comma-separated list of teams the member is part of | [optional] |
| **date_joined** | **String** | Date the member joined the organization |  |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2OrgsOrgNameMembersExportGet200ResponseInner.new(
  name: null,
  username: null,
  email: null,
  type: null,
  permission: null,
  teams: team-1, team-2,
  date_joined: 2020-01-01 15:00:51.193355 +0000 UTC
)
```

