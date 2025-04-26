# DockerHubClient::Tag

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **Integer** | tag ID | [optional] |
| **images** | [**Image**](.md) |  | [optional] |
| **creator** | **Integer** | ID of the user that pushed the tag | [optional] |
| **last_updated** | **String** | datetime of last update | [optional] |
| **last_updater** | **Integer** | ID of the last user that updated the tag | [optional] |
| **last_updater_username** | **String** | Hub username of the user that updated the tag | [optional] |
| **name** | **String** | name of the tag | [optional] |
| **repository** | **Integer** | repository ID | [optional] |
| **full_size** | **Integer** | compressed size (sum of all layers) of the tagged image | [optional] |
| **v2** | **String** | repository API version | [optional] |
| **status** | **String** | whether a tag has been pushed to or pulled in the past month | [optional] |
| **tag_last_pulled** | **String** | datetime of last pull | [optional] |
| **tag_last_pushed** | **String** | datetime of last push | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::Tag.new(
  id: null,
  images: null,
  creator: null,
  last_updated: 2021-01-05T21:06:53.506400Z,
  last_updater: null,
  last_updater_username: null,
  name: null,
  repository: null,
  full_size: null,
  v2: null,
  status: null,
  tag_last_pulled: 2021-01-05T21:06:53.506400Z,
  tag_last_pushed: 2021-01-05T21:06:53.506400Z
)
```

