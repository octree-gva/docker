# DockerHubClient::InvitesApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_invites_bulk_post**](InvitesApi.md#v2_invites_bulk_post) | **POST** /v2/invites/bulk | Bulk create invites |
| [**v2_invites_id_delete**](InvitesApi.md#v2_invites_id_delete) | **DELETE** /v2/invites/{id} | Cancel an invite |
| [**v2_invites_id_resend_patch**](InvitesApi.md#v2_invites_id_resend_patch) | **PATCH** /v2/invites/{id}/resend | Resend an invite |
| [**v2_orgs_org_name_invites_get**](InvitesApi.md#v2_orgs_org_name_invites_get) | **GET** /v2/orgs/{org_name}/invites | List org invites |


## v2_invites_bulk_post

> <V2InvitesBulkPost202Response> v2_invites_bulk_post(v2_invites_bulk_post_request, opts)

Bulk create invites

Create multiple invites by emails or DockerIDs. Only a team owner can create invites.  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::InvitesApi.new
v2_invites_bulk_post_request = DockerHubClient::V2InvitesBulkPostRequest.new({org: 'docker', invitees: ["invitee1DockerId", "invitee2@docker.com", "invitee3@docker.com"]}) # V2InvitesBulkPostRequest | 
opts = {
  x_analytics_client_feature: 'x_analytics_client_feature_example' # String | Optional string that indicates the feature used to submit the bulk invites (e.g.'file', 'web')
}

begin
  # Bulk create invites
  result = api_instance.v2_invites_bulk_post(v2_invites_bulk_post_request, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_bulk_post: #{e}"
end
```

#### Using the v2_invites_bulk_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2InvitesBulkPost202Response>, Integer, Hash)> v2_invites_bulk_post_with_http_info(v2_invites_bulk_post_request, opts)

```ruby
begin
  # Bulk create invites
  data, status_code, headers = api_instance.v2_invites_bulk_post_with_http_info(v2_invites_bulk_post_request, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2InvitesBulkPost202Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_bulk_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **v2_invites_bulk_post_request** | [**V2InvitesBulkPostRequest**](V2InvitesBulkPostRequest.md) |  |  |
| **x_analytics_client_feature** | **String** | Optional string that indicates the feature used to submit the bulk invites (e.g.&#39;file&#39;, &#39;web&#39;) | [optional] |

### Return type

[**V2InvitesBulkPost202Response**](V2InvitesBulkPost202Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## v2_invites_id_delete

> v2_invites_id_delete(id)

Cancel an invite

Mark the invite as cancelled so it doesn't show up on the list of pending invites  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::InvitesApi.new
id = 'id_example' # String | 

begin
  # Cancel an invite
  api_instance.v2_invites_id_delete(id)
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_id_delete: #{e}"
end
```

#### Using the v2_invites_id_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_invites_id_delete_with_http_info(id)

```ruby
begin
  # Cancel an invite
  data, status_code, headers = api_instance.v2_invites_id_delete_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_id_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_invites_id_resend_patch

> v2_invites_id_resend_patch(id)

Resend an invite

Resend a pending invite to the user, any org owner can resend an invite  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::InvitesApi.new
id = 'id_example' # String | 

begin
  # Resend an invite
  api_instance.v2_invites_id_resend_patch(id)
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_id_resend_patch: #{e}"
end
```

#### Using the v2_invites_id_resend_patch_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> v2_invites_id_resend_patch_with_http_info(id)

```ruby
begin
  # Resend an invite
  data, status_code, headers = api_instance.v2_invites_id_resend_patch_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_invites_id_resend_patch_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_org_name_invites_get

> <V2OrgsOrgNameInvitesGet200Response> v2_orgs_org_name_invites_get(org_name)

List org invites

Return all pending invites for a given org, only team owners can call this endpoint  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::InvitesApi.new
org_name = 'myorganization' # String | Name of the organization (namespace).

begin
  # List org invites
  result = api_instance.v2_orgs_org_name_invites_get(org_name)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_orgs_org_name_invites_get: #{e}"
end
```

#### Using the v2_orgs_org_name_invites_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<V2OrgsOrgNameInvitesGet200Response>, Integer, Hash)> v2_orgs_org_name_invites_get_with_http_info(org_name)

```ruby
begin
  # List org invites
  data, status_code, headers = api_instance.v2_orgs_org_name_invites_get_with_http_info(org_name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <V2OrgsOrgNameInvitesGet200Response>
rescue DockerHubClient::ApiError => e
  puts "Error when calling InvitesApi->v2_orgs_org_name_invites_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_name** | **String** | Name of the organization (namespace). |  |

### Return type

[**V2OrgsOrgNameInvitesGet200Response**](V2OrgsOrgNameInvitesGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

