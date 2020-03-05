# Home Assistant Add-on: Cloudflare DynDNS

Cloudflare offers free CDN including DNS Hosting.

## About

With this Add-on you can use your own Domain for Dynamic DNS using Cloudflares DNS Service.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor -> Add-on Store.**
1. Find the "letsencrypt" add-on and click it.
1. Click on the "INSTALL" button.

## How to use

To use this addon, you can choose between Cloudflare API Token (recommened) and API Key.

### 1. API Token

```yaml
api_token: token
domain: yourdomain.com
record: subdomain
retry_interval: 300
log_level: fatal
```

### 2. API Key

```yaml
api_key: token
email: email@mail.com
domain: yourdomain.com
record: subdomain
retry_interval: 300
log_level: fatal
```

#### Option `api_token`

This is the Cloudflare API Token. Currently, following Token permissions are required:

- Permissions
  - Zone:Zone:Read
  - Zone:DNS:Edit
- Zone Resources
  - All Zones

Unfortunately, it's currently not possible to give the token only permissions on the desired Zone, this is a known
issue at Cloudflare, hopefully this will be fixed in future.

#### Option `api_key`

This is the Cloudflare API Key. This needs to be used in combination with your email.

#### Option `email`

This is your email for the Cloudflare API Key.

#### Option `domain`

The Domain which should be used.

#### Option `record`

This is the subdomain name which should be updated.

If you want to use the root domain, please specify "@" here

#### Option `retry_interval`

The time in *seconds* were the Addon will check for IP changes.

#### Option `log_level`

Sets the desired log level. Following options are available:

- fatal *(default)*
- error
- warn
- info
- debug
