# DockerHubClient::OrgsApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_orgs_org_name_members_export_get**](OrgsApi.md#v2_orgs_org_name_members_export_get) | **GET** /v2/orgs/{org_name}/members/export | Export org members CSV |
| [**v2_orgs_org_name_members_get**](OrgsApi.md#v2_orgs_org_name_members_get) | **GET** /v2/orgs/{org_name}/members | List org members |
| [**v2_orgs_org_name_members_username_delete**](OrgsApi.md#v2_orgs_org_name_members_username_delete) | **DELETE** /v2/orgs/{org_name}/members/{username} | Remove member from org |
| [**v2_orgs_org_name_members_username_put**](OrgsApi.md#v2_orgs_org_name_members_username_put) | **PUT** /v2/orgs/{org_name}/members/{username} | Update org member (role) |


## v2_orgs_org_name_members_export_get

> <Array<V2OrgsOrgNameMembersExportGet200ResponseInner>> v2_orgs_org_name_members_export_get(org_name)

Export org members CSV

Export members of an organization as a CSV  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).

begin
  # Export org members CSV
  result = api_instance.v2_orgs_org_name_members_export_get(org_name)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_export_get: #{e}"
end
```

#### Using the v2_orgs_org_name_members_export_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<V2OrgsOrgNameMembersExportGet200ResponseInner>>, Integer, Hash)> v2_orgs_org_name_members_export_get_with_http_info(org_name)

```ruby
begin
  # Export org members CSV
  data, status_code, headers = api_instance.v2_orgs_org_name_members_export_get_with_http_info(org_name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<V2OrgsOrgNameMembersExportGet200ResponseInner>>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_export_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |

### Return type

[**Array&lt;V2OrgsOrgNameMembersExportGet200ResponseInner&gt;**](V2OrgsOrgNameMembersExportGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: text/csv, application/json


## v2_orgs_org_name_members_get

> <Array<OrgMemberPaginated>> v2_orgs_org_name_members_get(org_name, opts)

List org members

Returns a list of members for an organization.  _The following fields are only visible to orgs with insights enabled._  - `last_logged_in_at` - `last_seen_at` - `last_desktop_version`  To make visible, please see [View Insights for organization users](https://docs.docker.com/admin/organization/insights/#view-insights-for-organization-users).  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
opts = {
  search: 56, # Integer | Search term.
  page: 56, # Integer | Page number (starts on 1).
  page_size: 56, # Integer | Number of items (rows) per page.
  invites: true, # Boolean | Include invites in the response.
  type: 'all', # String | 
  role: 'owner' # String | 
}

begin
  # List org members
  result = api_instance.v2_orgs_org_name_members_get(org_name, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_get: #{e}"
end
```

#### Using the v2_orgs_org_name_members_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<OrgMemberPaginated>>, Integer, Hash)> v2_orgs_org_name_members_get_with_http_info(org_name, opts)

```ruby
begin
  # List org members
  data, status_code, headers = api_instance.v2_orgs_org_name_members_get_with_http_info(org_name, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<OrgMemberPaginated>>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **search** | **Integer** | Search term. | [optional] |
| **page** | **Integer** | Page number (starts on 1). | [optional] |
| **page_size** | **Integer** | Number of items (rows) per page. | [optional] |
| **invites** | **Boolean** | Include invites in the response. | [optional] |
| **type** | **String** |  | [optional] |
| **role** | **String** |  | [optional] |

### Return type

[**Array&lt;OrgMemberPaginated&gt;**](OrgMemberPaginated.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_members_username_delete

> v2_orgs_org_name_members_username_delete(org_name, username)

Remove member from org

Removes the member from the org, ie. all groups in the org, unless they're the last owner  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
username = 'jonsnow' # String | Username, identifier for the user (namespace, DockerID).

begin
  # Remove member from org
  api_instance.v2_orgs_org_name_members_username_delete(org_name, username)
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_username_delete: #{e}"
end
```

#### Using the v2_orgs_org_name_members_username_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_orgs_org_name_members_username_delete_with_http_info(org_name, username)

```ruby
begin
  # Remove member from org
  data, status_code, headers = api_instance.v2_orgs_org_name_members_username_delete_with_http_info(org_name, username)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_username_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **username** | **String** | Username, identifier for the user (namespace, DockerID). |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_members_username_put

> <OrgMember> v2_orgs_org_name_members_username_put(org_name, username, v2_orgs_org_name_members_username_put_request)

Update org member (role)

Updates the role of a member in the organization. ***Only users in the \"owners\" group of the organization can use this endpoint.***  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgsApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).
username = 'jonsnow' # String | Username, identifier for the user (namespace, DockerID).
v2_orgs_org_name_members_username_put_request = DockerHubClient::V2OrgsOrgNameMembersUsernamePutRequest.new({role: 'owner'}) # V2OrgsOrgNameMembersUsernamePutRequest | 

begin
  # Update org member (role)
  result = api_instance.v2_orgs_org_name_members_username_put(org_name, username, v2_orgs_org_name_members_username_put_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_username_put: #{e}"
end
```

#### Using the v2_orgs_org_name_members_username_put_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgMember>, Integer, Hash)> v2_orgs_org_name_members_username_put_with_http_info(org_name, username, v2_orgs_org_name_members_username_put_request)

```ruby
begin
  # Update org member (role)
  data, status_code, headers = api_instance.v2_orgs_org_name_members_username_put_with_http_info(org_name, username, v2_orgs_org_name_members_username_put_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgMember>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgsApi->v2_orgs_org_name_members_username_put_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |
| **username** | **String** | Username, identifier for the user (namespace, DockerID). |  |
| **v2_orgs_org_name_members_username_put_request** | [**V2OrgsOrgNameMembersUsernamePutRequest**](V2OrgsOrgNameMembersUsernamePutRequest.md) |  |  |

### Return type

[**OrgMember**](OrgMember.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

