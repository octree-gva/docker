# DockerHubClient::Error

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **errinfo** | **Array&lt;String&gt;** |  | [optional] |
| **detail** | **String** |  | [optional] |
| **message** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Error.new(
  errinfo: null,
  detail: null,
  message: null
)
```

