# DockerHubClient::RepositoriesApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_namespaces_namespace_repositories_repository_tags_get**](RepositoriesApi.md#v2_namespaces_namespace_repositories_repository_tags_get) | **GET** /v2/namespaces/{namespace}/repositories/{repository}/tags | List repository tags |
| [**v2_namespaces_namespace_repositories_repository_tags_head**](RepositoriesApi.md#v2_namespaces_namespace_repositories_repository_tags_head) | **HEAD** /v2/namespaces/{namespace}/repositories/{repository}/tags | Check repository tags |
| [**v2_namespaces_namespace_repositories_repository_tags_tag_get**](RepositoriesApi.md#v2_namespaces_namespace_repositories_repository_tags_tag_get) | **GET** /v2/namespaces/{namespace}/repositories/{repository}/tags/{tag} | Read repository tag |
| [**v2_namespaces_namespace_repositories_repository_tags_tag_head**](RepositoriesApi.md#v2_namespaces_namespace_repositories_repository_tags_tag_head) | **HEAD** /v2/namespaces/{namespace}/repositories/{repository}/tags/{tag} | Check repository tag |


## v2_namespaces_namespace_repositories_repository_tags_get

> <PaginatedTags> v2_namespaces_namespace_repositories_repository_tags_get(namespace, repository, opts)

List repository tags

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::RepositoriesApi.new
namespace = 'namespace_example' # String | 
repository = 'repository_example' # String | 
opts = {
  page: 56, # Integer | Page number to get. Defaults to 1.
  page_size: 56 # Integer | Number of items to get per page. Defaults to 10. Max of 100.
}

begin
  # List repository tags
  result = api_instance.v2_namespaces_namespace_repositories_repository_tags_get(namespace, repository, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_get: #{e}"
end
```

#### Using the v2_namespaces_namespace_repositories_repository_tags_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PaginatedTags>, Integer, Hash)> v2_namespaces_namespace_repositories_repository_tags_get_with_http_info(namespace, repository, opts)

```ruby
begin
  # List repository tags
  data, status_code, headers = api_instance.v2_namespaces_namespace_repositories_repository_tags_get_with_http_info(namespace, repository, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PaginatedTags>
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **namespace** | **String** |  |  |
| **repository** | **String** |  |  |
| **page** | **Integer** | Page number to get. Defaults to 1. | [optional] |
| **page_size** | **Integer** | Number of items to get per page. Defaults to 10. Max of 100. | [optional] |

### Return type

[**PaginatedTags**](PaginatedTags.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_namespaces_namespace_repositories_repository_tags_head

> v2_namespaces_namespace_repositories_repository_tags_head(namespace, repository)

Check repository tags

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::RepositoriesApi.new
namespace = 'namespace_example' # String | 
repository = 'repository_example' # String | 

begin
  # Check repository tags
  api_instance.v2_namespaces_namespace_repositories_repository_tags_head(namespace, repository)
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_head: #{e}"
end
```

#### Using the v2_namespaces_namespace_repositories_repository_tags_head_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_namespaces_namespace_repositories_repository_tags_head_with_http_info(namespace, repository)

```ruby
begin
  # Check repository tags
  data, status_code, headers = api_instance.v2_namespaces_namespace_repositories_repository_tags_head_with_http_info(namespace, repository)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_head_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **namespace** | **String** |  |  |
| **repository** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_namespaces_namespace_repositories_repository_tags_tag_get

> <Tag> v2_namespaces_namespace_repositories_repository_tags_tag_get(namespace, repository, tag)

Read repository tag

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::RepositoriesApi.new
namespace = 'namespace_example' # String | 
repository = 'repository_example' # String | 
tag = 'tag_example' # String | 

begin
  # Read repository tag
  result = api_instance.v2_namespaces_namespace_repositories_repository_tags_tag_get(namespace, repository, tag)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_tag_get: #{e}"
end
```

#### Using the v2_namespaces_namespace_repositories_repository_tags_tag_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Tag>, Integer, Hash)> v2_namespaces_namespace_repositories_repository_tags_tag_get_with_http_info(namespace, repository, tag)

```ruby
begin
  # Read repository tag
  data, status_code, headers = api_instance.v2_namespaces_namespace_repositories_repository_tags_tag_get_with_http_info(namespace, repository, tag)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Tag>
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_tag_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **namespace** | **String** |  |  |
| **repository** | **String** |  |  |
| **tag** | **String** |  |  |

### Return type

[**Tag**](Tag.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_namespaces_namespace_repositories_repository_tags_tag_head

> v2_namespaces_namespace_repositories_repository_tags_tag_head(namespace, repository, tag)

Check repository tag

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::RepositoriesApi.new
namespace = 'namespace_example' # String | 
repository = 'repository_example' # String | 
tag = 'tag_example' # String | 

begin
  # Check repository tag
  api_instance.v2_namespaces_namespace_repositories_repository_tags_tag_head(namespace, repository, tag)
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_tag_head: #{e}"
end
```

#### Using the v2_namespaces_namespace_repositories_repository_tags_tag_head_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_namespaces_namespace_repositories_repository_tags_tag_head_with_http_info(namespace, repository, tag)

```ruby
begin
  # Check repository tag
  data, status_code, headers = api_instance.v2_namespaces_namespace_repositories_repository_tags_tag_head_with_http_info(namespace, repository, tag)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling RepositoriesApi->v2_namespaces_namespace_repositories_repository_tags_tag_head_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **namespace** | **String** |  |  |
| **repository** | **String** |  |  |
| **tag** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

