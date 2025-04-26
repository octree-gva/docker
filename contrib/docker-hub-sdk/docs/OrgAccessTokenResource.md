# DockerHubClient::OrgAccessTokenResource

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of resource | [optional] |
| **path** | **String** | The path of the resource. The format of this will change depending on the type of resource. | [optional] |
| **scopes** | **Array&lt;String&gt;** | The scopes this token has access to | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::OrgAccessTokenResource.new(
  type: TYPE_REPO,
  path: myorg/myrepo,
  scopes: null
)
```

