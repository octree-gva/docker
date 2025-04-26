# DockerHubClient::Layer

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **digest** | **String** | image layer digest | [optional] |
| **size** | **Integer** | size of the layer | [optional] |
| **instruction** | **String** | Dockerfile instruction | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Layer.new(
  digest: null,
  size: null,
  instruction: null
)
```

