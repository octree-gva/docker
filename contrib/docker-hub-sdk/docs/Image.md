# DockerHubClient::Image

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **architecture** | **String** | CPU architecture | [optional] |
| **features** | **String** | CPU features | [optional] |
| **variant** | **String** | CPU variant | [optional] |
| **digest** | **String** | image digest | [optional] |
| **layers** | [**Array&lt;Layer&gt;**](Layer.md) |  | [optional] |
| **os** | **String** | operating system | [optional] |
| **os_features** | **String** | OS features | [optional] |
| **os_version** | **String** | OS version | [optional] |
| **size** | **Integer** | size of the image | [optional] |
| **status** | **String** | Status of the image | [optional] |
| **last_pulled** | **String** | datetime of last pull | [optional] |
| **last_pushed** | **String** | datetime of last push | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Image.new(
  architecture: null,
  features: null,
  variant: null,
  digest: null,
  layers: null,
  os: null,
  os_features: null,
  os_version: null,
  size: null,
  status: null,
  last_pulled: 2021-01-05T21:06:53.506400Z,
  last_pushed: 2021-01-05T21:06:53.506400Z
)
```

