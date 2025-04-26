# DockerHubClient::GroupsApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_orgs_org_name_groups_get**](GroupsApi.md#v2_orgs_org_name_groups_get) | **GET** /v2/orgs/{org_name}/groups | Get groups of an organization |
| [**v2_orgs_org_name_groups_group_name_delete**](GroupsApi.md#v2_orgs_org_name_groups_group_name_delete) | **DELETE** /v2/orgs/{org_name}/groups/{group_name} | Delete an organization group |
| [**v2_orgs_org_name_groups_group_name_get**](GroupsApi.md#v2_orgs_org_name_groups_group_name_get) | **GET** /v2/orgs/{org_name}/groups/{group_name} | Get a group of an organization |
| [**v2_orgs_org_name_groups_group_name_members_get**](GroupsApi.md#v2_orgs_org_name_groups_group_name_members_get) | **GET** /v2/orgs/{org_name}/groups/{group_name}/members | List members of a group |
| [**v2_orgs_org_name_groups_group_name_members_post**](GroupsApi.md#v2_orgs_org_name_groups_group_name_members_post) | **POST** /v2/orgs/{org_name}/groups/{group_name}/members | Add a member to a group |
| [**v2_orgs_org_name_groups_group_name_members_username_delete**](GroupsApi.md#v2_orgs_org_name_groups_group_name_members_username_delete) | **DELETE** /v2/orgs/{org_name}/groups/{group_name}/members/{username} | Remove a user from a group |
| [**v2_orgs_org_name_groups_group_name_patch**](GroupsApi.md#v2_orgs_org_name_groups_group_name_patch) | **PATCH** /v2/orgs/{org_name}/groups/{group_name} | Update some details for an organization group |
| [**v2_orgs_org_name_groups_group_name_put**](GroupsApi.md#v2_orgs_org_name_groups_group_name_put) | **PUT** /v2/orgs/{org_name}/groups/{group_name} | Update the details for an organization group |
| [**v2_orgs_org_name_groups_post**](GroupsApi.md#v2_orgs_org_name_groups_post) | **POST** /v2/orgs/{org_name}/groups | Create a new group |


## v2_orgs_org_name_groups_get

> <V2OrgsOrgNameGroupsGet200Response> v2_orgs_org_name_groups_get(org_name, opts)

Get groups of an organization

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
opts = {
  page: 56, # Integer | Page number (starts on 1).
  page_size: 56, # Integer | Number of items (rows) per page.
  username: 'username_example', # String | Get groups for the specified username in the organization.
  search: 'search_example' # String | Get groups for the specified group in the organization.
}

begin
  # Get groups of an organization
  result = api_instance.v2_orgs_org_name_groups_get(org_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_get: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2OrgsOrgNameGroupsGet200Response>, Integer, Hash)> v2_orgs_org_name_groups_get_with_http_info(org_name, opts)

```ruby
begin
  # Get groups of an organization
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_get_with_http_info(org_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2OrgsOrgNameGroupsGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **page** | **Integer** | Page number (starts on 1). | [optional] |
| **page_size** | **Integer** | Number of items (rows) per page. | [optional] |
| **username** | **String** | Get groups for the specified username in the organization. | [optional] |
| **search** | **String** | Get groups for the specified group in the organization. | [optional] |

### Return type

[**V2OrgsOrgNameGroupsGet200Response**](V2OrgsOrgNameGroupsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_delete

> v2_orgs_org_name_groups_group_name_delete(org_name, group_name)

Delete an organization group

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.

begin
  # Delete an organization group
  api_instance.v2_orgs_org_name_groups_group_name_delete(org_name, group_name)
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_delete: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_orgs_org_name_groups_group_name_delete_with_http_info(org_name, group_name)

```ruby
begin
  # Delete an organization group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_delete_with_http_info(org_name, group_name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_get

> <OrgGroup> v2_orgs_org_name_groups_group_name_get(org_name, group_name)

Get a group of an organization

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.

begin
  # Get a group of an organization
  result = api_instance.v2_orgs_org_name_groups_group_name_get(org_name, group_name)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_get: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgGroup>, Integer, Hash)> v2_orgs_org_name_groups_group_name_get_with_http_info(org_name, group_name)

```ruby
begin
  # Get a group of an organization
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_get_with_http_info(org_name, group_name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgGroup>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |

### Return type

[**OrgGroup**](OrgGroup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_members_get

> <V2OrgsOrgNameGroupsGroupNameMembersGet200Response> v2_orgs_org_name_groups_group_name_members_get(org_name, group_name, opts)

List members of a group

List the members (users) that are in a group. If user is owner of the org or has otherwise elevated permissions, they can search by email and the result will also contain emails.  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.
opts = {
  page: 56, # Integer | Page number (starts on 1).
  page_size: 56, # Integer | Number of items (rows) per page.
  search: 'search_example' # String | Search members by username, full_name or email.
}

begin
  # List members of a group
  result = api_instance.v2_orgs_org_name_groups_group_name_members_get(org_name, group_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_get: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_members_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2OrgsOrgNameGroupsGroupNameMembersGet200Response>, Integer, Hash)> v2_orgs_org_name_groups_group_name_members_get_with_http_info(org_name, group_name, opts)

```ruby
begin
  # List members of a group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_members_get_with_http_info(org_name, group_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2OrgsOrgNameGroupsGroupNameMembersGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |
| **page** | **Integer** | Page number (starts on 1). | [optional] |
| **page_size** | **Integer** | Number of items (rows) per page. | [optional] |
| **search** | **String** | Search members by username, full_name or email. | [optional] |

### Return type

[**V2OrgsOrgNameGroupsGroupNameMembersGet200Response**](V2OrgsOrgNameGroupsGroupNameMembersGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_members_post

> v2_orgs_org_name_groups_group_name_members_post(org_name, group_name, v2_orgs_org_name_groups_group_name_members_post_request)

Add a member to a group

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.
v2_orgs_org_name_groups_group_name_members_post_request = DockerHubClient::V2OrgsOrgNameGroupsGroupNameMembersPostRequest.new({member: 'jonsnow'}) # V2OrgsOrgNameGroupsGroupNameMembersPostRequest | 

begin
  # Add a member to a group
  api_instance.v2_orgs_org_name_groups_group_name_members_post(org_name, group_name, v2_orgs_org_name_groups_group_name_members_post_request)
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_post: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_members_post_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_orgs_org_name_groups_group_name_members_post_with_http_info(org_name, group_name, v2_orgs_org_name_groups_group_name_members_post_request)

```ruby
begin
  # Add a member to a group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_members_post_with_http_info(org_name, group_name, v2_orgs_org_name_groups_group_name_members_post_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |
| **v2_orgs_org_name_groups_group_name_members_post_request** | [**V2OrgsOrgNameGroupsGroupNameMembersPostRequest**](V2OrgsOrgNameGroupsGroupNameMembersPostRequest.md) |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_members_username_delete

> v2_orgs_org_name_groups_group_name_members_username_delete(org_name, group_name, username)

Remove a user from a group

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.
username = 'jonsnow' # String | Username, identifier for the user (namespace, DockerID).

begin
  # Remove a user from a group
  api_instance.v2_orgs_org_name_groups_group_name_members_username_delete(org_name, group_name, username)
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_username_delete: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_members_username_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_orgs_org_name_groups_group_name_members_username_delete_with_http_info(org_name, group_name, username)

```ruby
begin
  # Remove a user from a group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_members_username_delete_with_http_info(org_name, group_name, username)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_members_username_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |
| **username** | **String** | Username, identifier for the user (namespace, DockerID). |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_patch

> <OrgGroup> v2_orgs_org_name_groups_group_name_patch(org_name, group_name, opts)

Update some details for an organization group

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.
opts = {
  v2_orgs_org_name_groups_group_name_patch_request: DockerHubClient::V2OrgsOrgNameGroupsGroupNamePatchRequest.new # V2OrgsOrgNameGroupsGroupNamePatchRequest | 
}

begin
  # Update some details for an organization group
  result = api_instance.v2_orgs_org_name_groups_group_name_patch(org_name, group_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_patch: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_patch_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgGroup>, Integer, Hash)> v2_orgs_org_name_groups_group_name_patch_with_http_info(org_name, group_name, opts)

```ruby
begin
  # Update some details for an organization group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_patch_with_http_info(org_name, group_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgGroup>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_patch_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |
| **v2_orgs_org_name_groups_group_name_patch_request** | [**V2OrgsOrgNameGroupsGroupNamePatchRequest**](V2OrgsOrgNameGroupsGroupNamePatchRequest.md) |  | [optional] |

### Return type

[**OrgGroup**](OrgGroup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_orgs_org_name_groups_group_name_put

> <OrgGroup> v2_orgs_org_name_groups_group_name_put(org_name, group_name, opts)

Update the details for an organization group

<span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
group_name = 'developers' # String | Name of the group (team) in the organization.
opts = {
  v2_orgs_org_name_groups_post_request: DockerHubClient::V2OrgsOrgNameGroupsPostRequest.new({name: 'name_example'}) # V2OrgsOrgNameGroupsPostRequest | 
}

begin
  # Update the details for an organization group
  result = api_instance.v2_orgs_org_name_groups_group_name_put(org_name, group_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_put: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_group_name_put_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgGroup>, Integer, Hash)> v2_orgs_org_name_groups_group_name_put_with_http_info(org_name, group_name, opts)

```ruby
begin
  # Update the details for an organization group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_group_name_put_with_http_info(org_name, group_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgGroup>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_group_name_put_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **group_name** | **String** | Name of the group (team) in the organization. |  |
| **v2_orgs_org_name_groups_post_request** | [**V2OrgsOrgNameGroupsPostRequest**](V2OrgsOrgNameGroupsPostRequest.md) |  | [optional] |

### Return type

[**OrgGroup**](OrgGroup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_orgs_org_name_groups_post

> <OrgGroup> v2_orgs_org_name_groups_post(org_name, opts)

Create a new group

Create a new group within an organization.  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::GroupsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
opts = {
  v2_orgs_org_name_groups_post_request: DockerHubClient::V2OrgsOrgNameGroupsPostRequest.new({name: 'name_example'}) # V2OrgsOrgNameGroupsPostRequest | 
}

begin
  # Create a new group
  result = api_instance.v2_orgs_org_name_groups_post(org_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_post: #{e}"
end
```

#### Using the v2_orgs_org_name_groups_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgGroup>, Integer, Hash)> v2_orgs_org_name_groups_post_with_http_info(org_name, opts)

```ruby
begin
  # Create a new group
  data, status_code, headers = api_instance.v2_orgs_org_name_groups_post_with_http_info(org_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgGroup>
rescue DockerHubClient::ApiError => e
  puts "Error when calling GroupsApi->v2_orgs_org_name_groups_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **v2_orgs_org_name_groups_post_request** | [**V2OrgsOrgNameGroupsPostRequest**](V2OrgsOrgNameGroupsPostRequest.md) |  | [optional] |

### Return type

[**OrgGroup**](OrgGroup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

