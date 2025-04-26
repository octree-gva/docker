# DockerHubClient::AuditLogsApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**audit_logs_list_audit_actions**](AuditLogsApi.md#audit_logs_list_audit_actions) | **GET** /v2/auditlogs/{account}/actions | List audit log actions |
| [**audit_logs_list_audit_logs**](AuditLogsApi.md#audit_logs_list_audit_logs) | **GET** /v2/auditlogs/{account} | List audit log events |


## audit_logs_list_audit_actions

> <GetAuditActionsResponse> audit_logs_list_audit_actions(account)

List audit log actions

List audit log actions for a namespace to be used as a filter for querying audit log events.  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AuditLogsApi.new
account = 'account_example' # String | Namespace to query audit log actions for.

begin
  # List audit log actions
  result = api_instance.audit_logs_list_audit_actions(account)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuditLogsApi->audit_logs_list_audit_actions: #{e}"
end
```

#### Using the audit_logs_list_audit_actions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetAuditActionsResponse>, Integer, Hash)> audit_logs_list_audit_actions_with_http_info(account)

```ruby
begin
  # List audit log actions
  data, status_code, headers = api_instance.audit_logs_list_audit_actions_with_http_info(account)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetAuditActionsResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuditLogsApi->audit_logs_list_audit_actions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **account** | **String** | Namespace to query audit log actions for. |  |

### Return type

[**GetAuditActionsResponse**](GetAuditActionsResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## audit_logs_list_audit_logs

> <GetAuditLogsResponse> audit_logs_list_audit_logs(account, opts)

List audit log events

List audit log events for a given namespace.  <span class=\"oat\"></span> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'
# setup authorization
DockerHubClient.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = DockerHubClient::AuditLogsApi.new
account = 'account_example' # String | Namespace to query audit logs for.
opts = {
  action: 'action_example', # String | action name one of [\"repo.tag.push\", ...]. Optional parameter to filter specific audit log actions. 
  name: 'name_example', # String | name. Optional parameter to filter audit log events to a specific name. For repository events, this is the name of the repository. For organization events, this is the name of the organization. For team member events, this is the username of the team member. 
  actor: 'actor_example', # String | actor name. Optional parameter to filter audit log events to the specific user who triggered the event. 
  from: Time.parse('2013-10-20T19:20:30+01:00'), # Time | Start of the time window you wish to query audit events for.
  to: Time.parse('2013-10-20T19:20:30+01:00'), # Time | End of the time window you wish to query audit events for.
  page: 56, # Integer | page - specify page number. Page number to get.
  page_size: 56 # Integer | page_size - specify page size. Number of events to return per page.
}

begin
  # List audit log events
  result = api_instance.audit_logs_list_audit_logs(account, opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuditLogsApi->audit_logs_list_audit_logs: #{e}"
end
```

#### Using the audit_logs_list_audit_logs_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetAuditLogsResponse>, Integer, Hash)> audit_logs_list_audit_logs_with_http_info(account, opts)

```ruby
begin
  # List audit log events
  data, status_code, headers = api_instance.audit_logs_list_audit_logs_with_http_info(account, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetAuditLogsResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuditLogsApi->audit_logs_list_audit_logs_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **account** | **String** | Namespace to query audit logs for. |  |
| **action** | **String** | action name one of [\&quot;repo.tag.push\&quot;, ...]. Optional parameter to filter specific audit log actions.  | [optional] |
| **name** | **String** | name. Optional parameter to filter audit log events to a specific name. For repository events, this is the name of the repository. For organization events, this is the name of the organization. For team member events, this is the username of the team member.  | [optional] |
| **actor** | **String** | actor name. Optional parameter to filter audit log events to the specific user who triggered the event.  | [optional] |
| **from** | **Time** | Start of the time window you wish to query audit events for. | [optional] |
| **to** | **Time** | End of the time window you wish to query audit events for. | [optional] |
| **page** | **Integer** | page - specify page number. Page number to get. | [optional][default to 1] |
| **page_size** | **Integer** | page_size - specify page size. Number of events to return per page. | [optional][default to 25] |

### Return type

[**GetAuditLogsResponse**](GetAuditLogsResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

