# DockerHubClient::ScimUser

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **id** | **String** | The unique identifier for the user. A v4 UUID. | [optional] |
| **user_name** | **String** | The user&#39;s email address. This must be reachable via email. | [optional] |
| **name** | [**ScimUserName**](ScimUserName.md) |  | [optional] |
| **display_name** | **String** | The username in Docker. Also known as the \&quot;Docker ID\&quot;. | [optional] |
| **active** | **Boolean** |  | [optional] |
| **emails** | [**Array&lt;ScimEmail&gt;**](ScimEmail.md) |  | [optional] |
| **groups** | [**Array&lt;ScimGroup&gt;**](ScimGroup.md) |  | [optional] |
| **meta** | [**ScimUserMeta**](ScimUserMeta.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimUser.new(
  schemas: null,
  id: d80f7c79-7730-49d8-9a41-7c42fb622d9c,
  user_name: jon.snow@docker.com,
  name: null,
  display_name: jonsnow,
  active: true,
  emails: null,
  groups: null,
  meta: null
)
```

