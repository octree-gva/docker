# DockerHubClient::V2InvitesBulkPostRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org** | **String** | organization name |  |
| **team** | **String** | team name | [optional] |
| **role** | **String** | role for invitees | [optional] |
| **invitees** | **Array&lt;String&gt;** | list of invitees emails or Docker Ids |  |
| **dry_run** | **Boolean** | Optional, run through validation but don&#39;t actually change data. | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::V2InvitesBulkPostRequest.new(
  org: docker,
  team: owners,
  role: member,
  invitees: [&quot;invitee1DockerId&quot;,&quot;invitee2@docker.com&quot;,&quot;invitee3@docker.com&quot;],
  dry_run: true
)
```

