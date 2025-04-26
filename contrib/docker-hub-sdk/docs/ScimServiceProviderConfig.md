# DockerHubClient::ScimServiceProviderConfig

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **schemas** | **Array&lt;String&gt;** |  | [optional] |
| **documentation_uri** | **String** |  | [optional] |
| **patch** | [**ScimServiceProviderConfigPatch**](ScimServiceProviderConfigPatch.md) |  | [optional] |
| **bulk** | [**ScimServiceProviderConfigBulk**](ScimServiceProviderConfigBulk.md) |  | [optional] |
| **filter** | [**ScimServiceProviderConfigFilter**](ScimServiceProviderConfigFilter.md) |  | [optional] |
| **change_password** | [**ScimServiceProviderConfigChangePassword**](ScimServiceProviderConfigChangePassword.md) |  | [optional] |
| **sort** | [**ScimServiceProviderConfigSort**](ScimServiceProviderConfigSort.md) |  | [optional] |
| **etag** | [**ScimServiceProviderConfigChangePassword**](ScimServiceProviderConfigChangePassword.md) |  | [optional] |
| **authentication_schemes** | [**ScimServiceProviderConfigAuthenticationSchemes**](ScimServiceProviderConfigAuthenticationSchemes.md) |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimServiceProviderConfig.new(
  schemas: [&quot;urn:ietf:params:scim:schemas:core:2.0:ServiceProviderConfig&quot;],
  documentation_uri: ,
  patch: null,
  bulk: null,
  filter: null,
  change_password: null,
  sort: null,
  etag: null,
  authentication_schemes: null
)
```

