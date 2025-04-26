# DockerHubClient::RpcStatus

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **Integer** |  | [optional] |
| **message** | **String** |  | [optional] |
| **details** | [**Array&lt;ProtobufAny&gt;**](ProtobufAny.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::RpcStatus.new(
  code: null,
  message: null,
  details: null
)
```

