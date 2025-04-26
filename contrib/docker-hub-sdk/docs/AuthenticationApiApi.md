# DockerHubClient::AuthenticationApiApi

All URIs are relative to *https://hub.docker.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**auth_create_access_token**](AuthenticationApiApi.md#auth_create_access_token) | **POST** /v2/auth/token | Create access token |
| [**post_users2_fa_login**](AuthenticationApiApi.md#post_users2_fa_login) | **POST** /v2/users/2fa-login | Second factor authentication |
| [**post_users_login**](AuthenticationApiApi.md#post_users_login) | **POST** /v2/users/login | Create an authentication token |


## auth_create_access_token

> <AuthCreateTokenResponse> auth_create_access_token(opts)

Create access token

Creates and returns a short-lived access token in JWT format for use as a bearer when calling Docker APIs.  If successful, the access token returned should be used in the HTTP Authorization header like  `Authorization: Bearer {access_token}`.  _**If your organization has SSO enforced, you must use a personal access token (PAT) instead of a password.**_ 

### Examples

```ruby
require 'time'
require 'docker_hub_client'

api_instance = DockerHubClient::AuthenticationApiApi.new
opts = {
  auth_create_access_token_request: DockerHubClient::AuthCreateAccessTokenRequest.new({identifier: 'myusername', secret: 'dckr_pat_124509ugsdjga93'}) # AuthCreateAccessTokenRequest | 
}

begin
  # Create access token
  result = api_instance.auth_create_access_token(opts)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->auth_create_access_token: #{e}"
end
```

#### Using the auth_create_access_token_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AuthCreateTokenResponse>, Integer, Hash)> auth_create_access_token_with_http_info(opts)

```ruby
begin
  # Create access token
  data, status_code, headers = api_instance.auth_create_access_token_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AuthCreateTokenResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->auth_create_access_token_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **auth_create_access_token_request** | [**AuthCreateAccessTokenRequest**](AuthCreateAccessTokenRequest.md) |  | [optional] |

### Return type

[**AuthCreateTokenResponse**](AuthCreateTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## post_users2_fa_login

> <PostUsersLoginSuccessResponse> post_users2_fa_login(users2_fa_login_request)

Second factor authentication

When a user has two-factor authentication (2FA) enabled, this is the second call to perform after `/v2/users/login` call.  Creates and returns a bearer token in JWT format that you can use to authenticate with Docker Hub APIs.  The returned token is used in the HTTP Authorization header like `Authorization: Bearer {TOKEN}`.  Most Docker Hub APIs require this token either to consume or to get detailed information. For example, to list images in a private repository. 

### Examples

```ruby
require 'time'
require 'docker_hub_client'

api_instance = DockerHubClient::AuthenticationApiApi.new
users2_fa_login_request = DockerHubClient::Users2FALoginRequest.new({login_2fa_token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', code: '123456'}) # Users2FALoginRequest | Login details.

begin
  # Second factor authentication
  result = api_instance.post_users2_fa_login(users2_fa_login_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->post_users2_fa_login: #{e}"
end
```

#### Using the post_users2_fa_login_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PostUsersLoginSuccessResponse>, Integer, Hash)> post_users2_fa_login_with_http_info(users2_fa_login_request)

```ruby
begin
  # Second factor authentication
  data, status_code, headers = api_instance.post_users2_fa_login_with_http_info(users2_fa_login_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PostUsersLoginSuccessResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->post_users2_fa_login_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **users2_fa_login_request** | [**Users2FALoginRequest**](Users2FALoginRequest.md) | Login details. |  |

### Return type

[**PostUsersLoginSuccessResponse**](PostUsersLoginSuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## post_users_login

> <PostUsersLoginSuccessResponse> post_users_login(users_login_request)

Create an authentication token

Creates and returns a bearer token in JWT format that you can use to authenticate with Docker Hub APIs.  The returned token is used in the HTTP Authorization header like `Authorization: Bearer {TOKEN}`.  _**As of September 16, 2024, this route requires a personal access token (PAT) instead of a password if your organization has SSO enforced.**_  <div style=\"background-color:rgb(255, 165, 0, .25); padding:5px; border-radius:4px\">   <strong>Deprecated</strong>: Use [<a href=\"#tag/authentication-api/operation/AuthCreateAccessToken\">Create access token</a>] instead. </div> 

### Examples

```ruby
require 'time'
require 'docker_hub_client'

api_instance = DockerHubClient::AuthenticationApiApi.new
users_login_request = DockerHubClient::UsersLoginRequest.new({username: 'myusername', password: 'p@ssw0rd'}) # UsersLoginRequest | Login details.

begin
  # Create an authentication token
  result = api_instance.post_users_login(users_login_request)
  p result
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->post_users_login: #{e}"
end
```

#### Using the post_users_login_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PostUsersLoginSuccessResponse>, Integer, Hash)> post_users_login_with_http_info(users_login_request)

```ruby
begin
  # Create an authentication token
  data, status_code, headers = api_instance.post_users_login_with_http_info(users_login_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PostUsersLoginSuccessResponse>
rescue DockerHubClient::ApiError => e
  puts "Error when calling AuthenticationApiApi->post_users_login_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **users_login_request** | [**UsersLoginRequest**](UsersLoginRequest.md) | Login details. |  |

### Return type

[**PostUsersLoginSuccessResponse**](PostUsersLoginSuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

