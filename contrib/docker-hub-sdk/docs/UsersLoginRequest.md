# DockerHubClient::UsersLoginRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **username** | **String** | The username of the Docker Hub account to authenticate with. |  |
| **password** | **String** | The password or personal access token (PAT) of the Docker Hub account to authenticate with.  |  |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::UsersLoginRequest.new(
  username: myusername,
  password: p@ssw0rd
)
```

