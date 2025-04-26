# DockerHubClient::PatchAccessTokenRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **token_label** | **String** |  | [optional] |
| **is_active** | **Boolean** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::PatchAccessTokenRequest.new(
  token_label: My read only token,
  is_active: false
)
```

