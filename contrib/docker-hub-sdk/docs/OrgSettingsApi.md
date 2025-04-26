# DockerHubClient::OrgSettingsApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**v2_orgs_name_settings_get**](OrgSettingsApi.md#v2_orgs_name_settings_get) | **GET** /v2/orgs/{name}/settings | Get organization settings |
| [**v2_orgs_name_settings_put**](OrgSettingsApi.md#v2_orgs_name_settings_put) | **PUT** /v2/orgs/{name}/settings | Update organization settings |


## v2_orgs_name_settings_get

> <OrgSettings> v2_orgs_name_settings_get(name)

Get organization settings

Returns organization settings by name. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgSettingsApi.new
name = 'name_example' # String | Name of the organization.

begin
  # Get organization settings
  result = api_instance.v2_orgs_name_settings_get(name)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgSettingsApi->v2_orgs_name_settings_get: #{e}"
end
```

#### Using the v2_orgs_name_settings_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgSettings>, Integer, Hash)> v2_orgs_name_settings_get_with_http_info(name)

```ruby
begin
  # Get organization settings
  data, status_code, headers = api_instance.v2_orgs_name_settings_get_with_http_info(name)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgSettings>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgSettingsApi->v2_orgs_name_settings_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | Name of the organization. |  |

### Return type

[**OrgSettings**](OrgSettings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## v2_orgs_name_settings_put

> <OrgSettings> v2_orgs_name_settings_put(name, v2_orgs_name_settings_put_request)

Update organization settings

Updates an organization's settings. Some settings are only used when the organization is on a business plan.  ***Only users with administrative privileges for the organization (owner role) can modify these settings.***  The following settings are only used on a business plan: - `restricted_images` 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::OrgSettingsApi.new
name = 'name_example' # String | Name of the organization.
v2_orgs_name_settings_put_request = DockerHubClient::V2OrgsNameSettingsPutRequest.new({restricted_images: DockerHubClient::V2OrgsNameSettingsPutRequestRestrictedImages.new({enabled: true, allow_official_images: true, allow_verified_publishers: true})}) # V2OrgsNameSettingsPutRequest | 

begin
  # Update organization settings
  result = api_instance.v2_orgs_name_settings_put(name, v2_orgs_name_settings_put_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgSettingsApi->v2_orgs_name_settings_put: #{e}"
end
```

#### Using the v2_orgs_name_settings_put_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrgSettings>, Integer, Hash)> v2_orgs_name_settings_put_with_http_info(name, v2_orgs_name_settings_put_request)

```ruby
begin
  # Update organization settings
  data, status_code, headers = api_instance.v2_orgs_name_settings_put_with_http_info(name, v2_orgs_name_settings_put_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrgSettings>
rescue DockerHubClient::ApiError => e
  puts "Error when calling OrgSettingsApi->v2_orgs_name_settings_put_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | Name of the organization. |  |
| **v2_orgs_name_settings_put_request** | [**V2OrgsNameSettingsPutRequest**](V2OrgsNameSettingsPutRequest.md) |  |  |

### Return type

[**OrgSettings**](OrgSettings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

