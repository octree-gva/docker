# DockerHubClient::ScimServiceProviderConfigAuthenticationSchemes

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **spec_uri** | **String** |  | [optional] |
| **type** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::ScimServiceProviderConfigAuthenticationSchemes.new(
  name: OAuth 2.0 Bearer Token,
  description: The OAuth 2.0 Bearer Token Authentication scheme. OAuth enables clients to access protected resources by obtaining an access token, which is defined in RFC 6750 as &quot;a string representing an access authorization issued to the client&quot;, rather than using the resource owner&#39;s credentials directly.,
  spec_uri: http://tools.ietf.org/html/rfc6750,
  type: oauthbearertoken
)
```

