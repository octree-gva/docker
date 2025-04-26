# DockerHubClient::ScimApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_scim20_resource_types_get**](ScimApi.md#v2_scim20_resource_types_get) | **GET** /v2/scim/2.0/ResourceTypes | List resource types |
| [**v2_scim20_resource_types_name_get**](ScimApi.md#v2_scim20_resource_types_name_get) | **GET** /v2/scim/2.0/ResourceTypes/{name} | Get a resource type |
| [**v2_scim20_schemas_get**](ScimApi.md#v2_scim20_schemas_get) | **GET** /v2/scim/2.0/Schemas | List schemas |
| [**v2_scim20_schemas_id_get**](ScimApi.md#v2_scim20_schemas_id_get) | **GET** /v2/scim/2.0/Schemas/{id} | Get a schema |
| [**v2_scim20_service_provider_config_get**](ScimApi.md#v2_scim20_service_provider_config_get) | **GET** /v2/scim/2.0/ServiceProviderConfig | Get service provider config |
| [**v2_scim20_users_get**](ScimApi.md#v2_scim20_users_get) | **GET** /v2/scim/2.0/Users | List users |
| [**v2_scim20_users_id_get**](ScimApi.md#v2_scim20_users_id_get) | **GET** /v2/scim/2.0/Users/{id} | Get a user |
| [**v2_scim20_users_id_put**](ScimApi.md#v2_scim20_users_id_put) | **PUT** /v2/scim/2.0/Users/{id} | Update a user |
| [**v2_scim20_users_post**](ScimApi.md#v2_scim20_users_post) | **POST** /v2/scim/2.0/Users | Create user |


## v2_scim20_resource_types_get

> <V2Scim20ResourceTypesGet200Response> v2_scim20_resource_types_get

List resource types

Returns all resource types supported for the SCIM configuration. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new

begin
  # List resource types
  result = api_instance.v2_scim20_resource_types_get
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_resource_types_get: #{e}"
end
```

#### Using the v2_scim20_resource_types_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2Scim20ResourceTypesGet200Response>, Integer, Hash)> v2_scim20_resource_types_get_with_http_info

```ruby
begin
  # List resource types
  data, status_code, headers = api_instance.v2_scim20_resource_types_get_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2Scim20ResourceTypesGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_resource_types_get_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**V2Scim20ResourceTypesGet200Response**](V2Scim20ResourceTypesGet200Response.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_resource_types_name_get

> <ScimResourceType> v2_scim20_resource_types_name_get(name)

Get a resource type

Returns a resource type by name. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
name = 'User' # String | 

begin
  # Get a resource type
  result = api_instance.v2_scim20_resource_types_name_get(name)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_resource_types_name_get: #{e}"
end
```

#### Using the v2_scim20_resource_types_name_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimResourceType>, Integer, Hash)> v2_scim20_resource_types_name_get_with_http_info(name)

```ruby
begin
  # Get a resource type
  data, status_code, headers = api_instance.v2_scim20_resource_types_name_get_with_http_info(name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimResourceType>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_resource_types_name_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** |  |  |

### Return type

[**ScimResourceType**](ScimResourceType.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_schemas_get

> <V2Scim20SchemasGet200Response> v2_scim20_schemas_get

List schemas

Returns all schemas supported for the SCIM configuration. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new

begin
  # List schemas
  result = api_instance.v2_scim20_schemas_get
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_schemas_get: #{e}"
end
```

#### Using the v2_scim20_schemas_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2Scim20SchemasGet200Response>, Integer, Hash)> v2_scim20_schemas_get_with_http_info

```ruby
begin
  # List schemas
  data, status_code, headers = api_instance.v2_scim20_schemas_get_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2Scim20SchemasGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_schemas_get_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**V2Scim20SchemasGet200Response**](V2Scim20SchemasGet200Response.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_schemas_id_get

> <ScimSchema> v2_scim20_schemas_id_get(id)

Get a schema

Returns a schema by ID. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
id = 'urn:ietf:params:scim:schemas:core:2.0:User' # String | 

begin
  # Get a schema
  result = api_instance.v2_scim20_schemas_id_get(id)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_schemas_id_get: #{e}"
end
```

#### Using the v2_scim20_schemas_id_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimSchema>, Integer, Hash)> v2_scim20_schemas_id_get_with_http_info(id)

```ruby
begin
  # Get a schema
  data, status_code, headers = api_instance.v2_scim20_schemas_id_get_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimSchema>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_schemas_id_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  |  |

### Return type

[**ScimSchema**](ScimSchema.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_service_provider_config_get

> <ScimServiceProviderConfig> v2_scim20_service_provider_config_get

Get service provider config

Returns a service provider config for Docker's configuration. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new

begin
  # Get service provider config
  result = api_instance.v2_scim20_service_provider_config_get
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_service_provider_config_get: #{e}"
end
```

#### Using the v2_scim20_service_provider_config_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimServiceProviderConfig>, Integer, Hash)> v2_scim20_service_provider_config_get_with_http_info

```ruby
begin
  # Get service provider config
  data, status_code, headers = api_instance.v2_scim20_service_provider_config_get_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimServiceProviderConfig>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_service_provider_config_get_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**ScimServiceProviderConfig**](ScimServiceProviderConfig.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_users_get

> <V2Scim20UsersGet200Response> v2_scim20_users_get(opts)

List users

Returns paginated users for an organization. Use `startIndex` and `count` query parameters to receive paginated results.  **Sorting:**  Sorting allows you to specify the order in which resources are returned by specifying a combination of `sortBy` and `sortOrder` query parameters.  The `sortBy` parameter specifies the attribute whose value will be used to order the returned responses. The `sortOrder` parameter defines the order in which the `sortBy` parameter is applied. Allowed values are \"ascending\" and \"descending\".  **Filtering:**  You can request a subset of resources by specifying the `filter` query parameter containing a filter expression. Attribute names and attribute operators used in filters are case insensitive. The filter parameter must contain at least one valid expression. Each expression must contain an attribute name followed by an attribute operator and an optional value.  Supported operators are listed below.  - `eq` equal - `ne` not equal - `co` contains - `sw` starts with - `and` Logical \"and\" - `or` Logical \"or\" - `not` \"Not\" function - `()` Precedence grouping 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
opts = {
  start_index: 1, # Integer | 
  count: 10, # Integer | 
  filter: 'userName eq "jon.snow@docker.com"', # String | 
  attributes: 'userName,displayName', # String | Comma delimited list of attributes to limit to in the response.
  sort_order: 'ascending', # String | 
  sort_by: 'userName' # String | User attribute to sort by.
}

begin
  # List users
  result = api_instance.v2_scim20_users_get(opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_get: #{e}"
end
```

#### Using the v2_scim20_users_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2Scim20UsersGet200Response>, Integer, Hash)> v2_scim20_users_get_with_http_info(opts)

```ruby
begin
  # List users
  data, status_code, headers = api_instance.v2_scim20_users_get_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2Scim20UsersGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **start_index** | **Integer** |  | [optional] |
| **count** | **Integer** |  | [optional] |
| **filter** | **String** |  | [optional] |
| **attributes** | **String** | Comma delimited list of attributes to limit to in the response. | [optional] |
| **sort_order** | **String** |  | [optional] |
| **sort_by** | **String** | User attribute to sort by. | [optional] |

### Return type

[**V2Scim20UsersGet200Response**](V2Scim20UsersGet200Response.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_users_id_get

> <ScimUser> v2_scim20_users_id_get(id)

Get a user

Returns a user by ID. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
id = 'd80f7c79-7730-49d8-9a41-7c42fb622d9c' # String | The user ID.

begin
  # Get a user
  result = api_instance.v2_scim20_users_id_get(id)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_id_get: #{e}"
end
```

#### Using the v2_scim20_users_id_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimUser>, Integer, Hash)> v2_scim20_users_id_get_with_http_info(id)

```ruby
begin
  # Get a user
  data, status_code, headers = api_instance.v2_scim20_users_id_get_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimUser>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_id_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user ID. |  |

### Return type

[**ScimUser**](ScimUser.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/scim+json


## v2_scim20_users_id_put

> <ScimUser> v2_scim20_users_id_put(id, v2_scim20_users_id_put_request)

Update a user

Updates a user. This route is used to change the user's name, activate, and deactivate the user. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
id = 'd80f7c79-7730-49d8-9a41-7c42fb622d9c' # String | The user ID.
v2_scim20_users_id_put_request = DockerHubClient::V2Scim20UsersIdPutRequest.new({schemas: ['urn:ietf:params:scim:schemas:core:2.0:User']}) # V2Scim20UsersIdPutRequest | 

begin
  # Update a user
  result = api_instance.v2_scim20_users_id_put(id, v2_scim20_users_id_put_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_id_put: #{e}"
end
```

#### Using the v2_scim20_users_id_put_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimUser>, Integer, Hash)> v2_scim20_users_id_put_with_http_info(id, v2_scim20_users_id_put_request)

```ruby
begin
  # Update a user
  data, status_code, headers = api_instance.v2_scim20_users_id_put_with_http_info(id, v2_scim20_users_id_put_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimUser>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_id_put_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user ID. |  |
| **v2_scim20_users_id_put_request** | [**V2Scim20UsersIdPutRequest**](V2Scim20UsersIdPutRequest.md) |  |  |

### Return type

[**ScimUser**](ScimUser.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: application/scim+json
- **Accept**: application/scim+json


## v2_scim20_users_post

> <ScimUser> v2_scim20_users_post(v2_scim20_users_post_request)

Create user

Creates a user. If the user already exists by email, they are assigned to the organization on the \"company\" team. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization: bearerSCIMAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::ScimApi.new
v2_scim20_users_post_request = DockerHubClient::V2Scim20UsersPostRequest.new({schemas: ['urn:ietf:params:scim:schemas:core:2.0:User'], user_name: 'jon.snow@docker.com'}) # V2Scim20UsersPostRequest | 

begin
  # Create user
  result = api_instance.v2_scim20_users_post(v2_scim20_users_post_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_post: #{e}"
end
```

#### Using the v2_scim20_users_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ScimUser>, Integer, Hash)> v2_scim20_users_post_with_http_info(v2_scim20_users_post_request)

```ruby
begin
  # Create user
  data, status_code, headers = api_instance.v2_scim20_users_post_with_http_info(v2_scim20_users_post_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ScimUser>
rescue DockerHubClient::ApiError => e
  puts "Error when calling ScimApi->v2_scim20_users_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **v2_scim20_users_post_request** | [**V2Scim20UsersPostRequest**](V2Scim20UsersPostRequest.md) |  |  |

### Return type

[**ScimUser**](ScimUser.md)

### Authorization

[bearerSCIMAuth](../README.md#bearerSCIMAuth)

### HTTP request headers

- **Content-Type**: application/scim+json
- **Accept**: application/scim+json

