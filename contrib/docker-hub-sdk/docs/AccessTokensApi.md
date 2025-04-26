# DockerHubClient::AccessTokensApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_access_tokens_get**](AccessTokensApi.md#v2_access_tokens_get) | **GET** /v2/access-tokens | List personal access tokens |
| [**v2_access_tokens_post**](AccessTokensApi.md#v2_access_tokens_post) | **POST** /v2/access-tokens | Create personal access token |
| [**v2_access_tokens_uuid_delete**](AccessTokensApi.md#v2_access_tokens_uuid_delete) | **DELETE** /v2/access-tokens/{uuid} | Delete personal access token |
| [**v2_access_tokens_uuid_get**](AccessTokensApi.md#v2_access_tokens_uuid_get) | **GET** /v2/access-tokens/{uuid} | Get personal access token |
| [**v2_access_tokens_uuid_patch**](AccessTokensApi.md#v2_access_tokens_uuid_patch) | **PATCH** /v2/access-tokens/{uuid} | Update personal access token |


## v2_access_tokens_get

> <GetAccessTokensResponse> v2_access_tokens_get(opts)

List personal access tokens

Returns a paginated list of personal access tokens.

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AccessTokensApi.new
opts = {
  page: 8.14, # Float | 
  page_size: 8.14 # Float | 
}

begin
  # List personal access tokens
  result = api_instance.v2_access_tokens_get(opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_get: #{e}"
end
```

#### Using the v2_access_tokens_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetAccessTokensResponse>, Integer, Hash)> v2_access_tokens_get_with_http_info(opts)

```ruby
begin
  # List personal access tokens
  data, status_code, headers = api_instance.v2_access_tokens_get_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetAccessTokensResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page** | **Float** |  | [optional][default to 1] |
| **page_size** | **Float** |  | [optional][default to 10] |

### Return type

[**GetAccessTokensResponse**](GetAccessTokensResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_access_tokens_post

> <AccessToken> v2_access_tokens_post(create_access_token_request)

Create personal access token

Creates and returns a personal access token.

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AccessTokensApi.new
create_access_token_request = DockerHubClient::CreateAccessTokenRequest.new({token_label: 'My read only token', scopes: ["repo: read"]}) # CreateAccessTokenRequest | 

begin
  # Create personal access token
  result = api_instance.v2_access_tokens_post(create_access_token_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_post: #{e}"
end
```

#### Using the v2_access_tokens_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AccessToken>, Integer, Hash)> v2_access_tokens_post_with_http_info(create_access_token_request)

```ruby
begin
  # Create personal access token
  data, status_code, headers = api_instance.v2_access_tokens_post_with_http_info(create_access_token_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AccessToken>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_access_token_request** | [**CreateAccessTokenRequest**](CreateAccessTokenRequest.md) |  |  |

### Return type

[**AccessToken**](AccessToken.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_access_tokens_uuid_delete

> v2_access_tokens_uuid_delete(uuid)

Delete personal access token

Deletes a personal access token permanently. This cannot be undone. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AccessTokensApi.new
uuid = 'uuid_example' # String | 

begin
  # Delete personal access token
  api_instance.v2_access_tokens_uuid_delete(uuid)
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_delete: #{e}"
end
```

#### Using the v2_access_tokens_uuid_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_access_tokens_uuid_delete_with_http_info(uuid)

```ruby
begin
  # Delete personal access token
  data, status_code, headers = api_instance.v2_access_tokens_uuid_delete_with_http_info(uuid)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **uuid** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_access_tokens_uuid_get

> <V2AccessTokensUuidGet200Response> v2_access_tokens_uuid_get(uuid)

Get personal access token

Returns a personal access token by UUID.

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AccessTokensApi.new
uuid = 'uuid_example' # String | 

begin
  # Get personal access token
  result = api_instance.v2_access_tokens_uuid_get(uuid)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_get: #{e}"
end
```

#### Using the v2_access_tokens_uuid_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2AccessTokensUuidGet200Response>, Integer, Hash)> v2_access_tokens_uuid_get_with_http_info(uuid)

```ruby
begin
  # Get personal access token
  data, status_code, headers = api_instance.v2_access_tokens_uuid_get_with_http_info(uuid)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2AccessTokensUuidGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **uuid** | **String** |  |  |

### Return type

[**V2AccessTokensUuidGet200Response**](V2AccessTokensUuidGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_access_tokens_uuid_patch

> <AccessToken> v2_access_tokens_uuid_patch(uuid, patch_access_token_request)

Update personal access token

Updates a personal access token partially. You can either update the token's label or enable/disable it. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AccessTokensApi.new
uuid = 'uuid_example' # String | 
patch_access_token_request = DockerHubClient::PatchAccessTokenRequest.new # PatchAccessTokenRequest | 

begin
  # Update personal access token
  result = api_instance.v2_access_tokens_uuid_patch(uuid, patch_access_token_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_patch: #{e}"
end
```

#### Using the v2_access_tokens_uuid_patch_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AccessToken>, Integer, Hash)> v2_access_tokens_uuid_patch_with_http_info(uuid, patch_access_token_request)

```ruby
begin
  # Update personal access token
  data, status_code, headers = api_instance.v2_access_tokens_uuid_patch_with_http_info(uuid, patch_access_token_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AccessToken>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AccessTokensApi->v2_access_tokens_uuid_patch_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **uuid** | **String** |  |  |
| **patch_access_token_request** | [**PatchAccessTokenRequest**](PatchAccessTokenRequest.md) |  |  |

### Return type

[**AccessToken**](AccessToken.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

