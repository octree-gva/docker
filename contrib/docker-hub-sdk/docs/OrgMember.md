# DockerHubClient::OrgMember

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | User&#39;s email address | [optional] |
| **role** | **String** | User&#39;s role in the Organization | [optional] |
| **groups** | **Array&lt;String&gt;** | Groups (Teams) that the user is member of | [optional] |
| **is_guest** | **Boolean** | If the organization has verfied domains, members that have email addresses outside of those domains will be flagged as guests. | [optional] |
| **primary_email** | **String** | The user&#39;s email primary address. | [optional] |
| **last_logged_in_at** | **Time** | Last time the user logged in. To access this field, you must have insights visible for your organization. See  [Insights](https://docs.docker.com/admin/organization/insights/#view-insights-for-organization-users).  | [optional] |
| **last_seen_at** | **Time** | Last time the user was seen. To access this field, you must have insights visible for your organization. See  [Insights](https://docs.docker.com/admin/organization/insights/#view-insights-for-organization-users).  | [optional] |
| **last_desktop_version** | **String** | Last desktop version the user used. To access this field, you must have insights visible for your organization. See  [Insights](https://docs.docker.com/admin/organization/insights/#view-insights-for-organization-users).  | [optional] |
| **id** | **String** | The UUID trimmed | [optional] |
| **company** | **String** |  | [optional] |
| **date_joined** | **String** |  | [optional] |
| **full_name** | **String** |  | [optional] |
| **gravatar_email** | **String** |  | [optional] |
| **gravatar_url** | **String** |  | [optional] |
| **location** | **String** |  | [optional] |
| **profile_url** | **String** |  | [optional] |
| **type** | **String** |  | [optional] |
| **username** | **String** |  | [optional] |

## Example

```ruby
require 'docker_hub_client'

instance = DockerHubClient::OrgMember.new(
  email: example@docker.com,
  role: Owner,
  groups: [&quot;developers&quot;,&quot;owners&quot;],
  is_guest: false,
  primary_email: example@docker.com,
  last_logged_in_at: 2021-01-05T21:06:53.506400Z,
  last_seen_at: 2021-01-05T21:06:53.506400Z,
  last_desktop_version: 4.29.0,
  id: 0ab70deb065a43fcacd55d48caa945d8,
  company: Docker Inc,
  date_joined: 2021-01-05T21:06:53.506400Z,
  full_name: Jon Snow,
  gravatar_email: null,
  gravatar_url: null,
  location: null,
  profile_url: null,
  type: User,
  username: dockeruser
)
```

