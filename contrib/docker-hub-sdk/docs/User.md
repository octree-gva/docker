# DockerHubClient::User

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The UUID trimmed | [optional] |
| **company** | **String** |  | [optional] |
| **date_joined** | **String** |  | [optional] |
| **full_name** | **String** |  | [optional] |
| **gravatar_email** | **String** |  | [optional] |
| **gravatar_url** | **String** |  | [optional] |
| **location** | **String** |  | [optional] |
| **profile_url** | **String** |  | [optional] |
| **type** | **String** |  | [optional] |
| **username** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::User.new(
  id: 0ab70deb065a43fcacd55d48caa945d8,
  company: Docker Inc,
  date_joined: 2021-01-05T21:06:53.506400Z,
  full_name: Jon Snow,
  gravatar_email: null,
  gravatar_url: null,
  location: null,
  profile_url: null,
  type: User,
  username: dockeruser
)
```

