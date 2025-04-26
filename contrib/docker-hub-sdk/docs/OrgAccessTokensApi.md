# DockerHubClient::OrgAccessTokensApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_orgs_name_access_tokens_get**](OrgAccessTokensApi.md#v2_orgs_name_access_tokens_get) | **GET** /v2/orgs/{name}/access-tokens | List access tokens |
| [**v2_orgs_name_access_tokens_post**](OrgAccessTokensApi.md#v2_orgs_name_access_tokens_post) | **POST** /v2/orgs/{name}/access-tokens | Create access token |
| [**v2_orgs_org_name_access_tokens_access_token_id_delete**](OrgAccessTokensApi.md#v2_orgs_org_name_access_tokens_access_token_id_delete) | **DELETE** /v2/orgs/{org_name}/access-tokens/{access_token_id} | Delete access token |
| [**v2_orgs_org_name_access_tokens_access_token_id_get**](OrgAccessTokensApi.md#v2_orgs_org_name_access_tokens_access_token_id_get) | **GET** /v2/orgs/{org_name}/access-tokens/{access_token_id} | Get access token |
| [**v2_orgs_org_name_access_tokens_access_token_id_patch**](OrgAccessTokensApi.md#v2_orgs_org_name_access_tokens_access_token_id_patch) | **PATCH** /v2/orgs/{org_name}/access-tokens/{access_token_id} | Update access token |


## v2_orgs_name_access_tokens_get

> <GetOrgAccessTokensResponse> v2_orgs_name_access_tokens_get(opts)

List access tokens

List access tokens for an organization. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgAccessTokensApi.new
opts = {
  page: 8.14, # Float | 
  page_size: 8.14 # Float | 
}

begin
  # List access tokens
  result = api_instance.v2_orgs_name_access_tokens_get(opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_name_access_tokens_get: #{e}"
end
```

#### Using the v2_orgs_name_access_tokens_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrgAccessTokensResponse>, Integer, Hash)> v2_orgs_name_access_tokens_get_with_http_info(opts)

```ruby
begin
  # List access tokens
  data, status_code, headers = api_instance.v2_orgs_name_access_tokens_get_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrgAccessTokensResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_name_access_tokens_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page** | **Float** |  | [optional][default to 1] |
| **page_size** | **Float** |  | [optional][default to 10] |

### Return type

[**GetOrgAccessTokensResponse**](GetOrgAccessTokensResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_name_access_tokens_post

> <CreateOrgAccessTokenResponse> v2_orgs_name_access_tokens_post(create_org_access_token_request)

Create access token

Create an access token for an organization. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgAccessTokensApi.new
create_org_access_token_request = DockerHubClient::CreateOrgAccessTokenRequest.new # CreateOrgAccessTokenRequest | 

begin
  # Create access token
  result = api_instance.v2_orgs_name_access_tokens_post(create_org_access_token_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_name_access_tokens_post: #{e}"
end
```

#### Using the v2_orgs_name_access_tokens_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateOrgAccessTokenResponse>, Integer, Hash)> v2_orgs_name_access_tokens_post_with_http_info(create_org_access_token_request)

```ruby
begin
  # Create access token
  data, status_code, headers = api_instance.v2_orgs_name_access_tokens_post_with_http_info(create_org_access_token_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateOrgAccessTokenResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_name_access_tokens_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_org_access_token_request** | [**CreateOrgAccessTokenRequest**](CreateOrgAccessTokenRequest.md) |  |  |

### Return type

[**CreateOrgAccessTokenResponse**](CreateOrgAccessTokenResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_orgs_org_name_access_tokens_access_token_id_delete

> v2_orgs_org_name_access_tokens_access_token_id_delete(org_name, access_token_id)

Delete access token

Delete a specific access token for an organization. This action cannot be undone. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgAccessTokensApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
access_token_id = 'a7a5ef25-8889-43a0-8cc7-f2a94268e861' # String | The ID of the access token to retrieve

begin
  # Delete access token
  api_instance.v2_orgs_org_name_access_tokens_access_token_id_delete(org_name, access_token_id)
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_delete: #{e}"
end
```

#### Using the v2_orgs_org_name_access_tokens_access_token_id_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_orgs_org_name_access_tokens_access_token_id_delete_with_http_info(org_name, access_token_id)

```ruby
begin
  # Delete access token
  data, status_code, headers = api_instance.v2_orgs_org_name_access_tokens_access_token_id_delete_with_http_info(org_name, access_token_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **access_token_id** | **String** | The ID of the access token to retrieve |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_access_tokens_access_token_id_get

> <GetOrgAccessTokenResponse> v2_orgs_org_name_access_tokens_access_token_id_get(org_name, access_token_id)

Get access token

Get details of a specific access token for an organization. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgAccessTokensApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
access_token_id = 'a7a5ef25-8889-43a0-8cc7-f2a94268e861' # String | The ID of the access token to retrieve

begin
  # Get access token
  result = api_instance.v2_orgs_org_name_access_tokens_access_token_id_get(org_name, access_token_id)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_get: #{e}"
end
```

#### Using the v2_orgs_org_name_access_tokens_access_token_id_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrgAccessTokenResponse>, Integer, Hash)> v2_orgs_org_name_access_tokens_access_token_id_get_with_http_info(org_name, access_token_id)

```ruby
begin
  # Get access token
  data, status_code, headers = api_instance.v2_orgs_org_name_access_tokens_access_token_id_get_with_http_info(org_name, access_token_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrgAccessTokenResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **access_token_id** | **String** | The ID of the access token to retrieve |  |

### Return type

[**GetOrgAccessTokenResponse**](GetOrgAccessTokenResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_access_tokens_access_token_id_patch

> <UpdateOrgAccessTokenResponse> v2_orgs_org_name_access_tokens_access_token_id_patch(org_name, access_token_id, update_org_access_token_request)

Update access token

Update a specific access token for an organization. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgAccessTokensApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
access_token_id = 'a7a5ef25-8889-43a0-8cc7-f2a94268e861' # String | The ID of the access token to retrieve
update_org_access_token_request = DockerHubClient::UpdateOrgAccessTokenRequest.new # UpdateOrgAccessTokenRequest | 

begin
  # Update access token
  result = api_instance.v2_orgs_org_name_access_tokens_access_token_id_patch(org_name, access_token_id, update_org_access_token_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_patch: #{e}"
end
```

#### Using the v2_orgs_org_name_access_tokens_access_token_id_patch_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateOrgAccessTokenResponse>, Integer, Hash)> v2_orgs_org_name_access_tokens_access_token_id_patch_with_http_info(org_name, access_token_id, update_org_access_token_request)

```ruby
begin
  # Update access token
  data, status_code, headers = api_instance.v2_orgs_org_name_access_tokens_access_token_id_patch_with_http_info(org_name, access_token_id, update_org_access_token_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateOrgAccessTokenResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgAccessTokensApi->v2_orgs_org_name_access_tokens_access_token_id_patch_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **access_token_id** | **String** | The ID of the access token to retrieve |  |
| **update_org_access_token_request** | [**UpdateOrgAccessTokenRequest**](UpdateOrgAccessTokenRequest.md) |  |  |

### Return type

[**UpdateOrgAccessTokenResponse**](UpdateOrgAccessTokenResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

