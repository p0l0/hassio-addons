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
apiToken: token
domain: yourdomain.com
record: subdomain
```

### 2. API Key

```yaml
apiKey: token
email: email@mail.com
domain: yourdomain.com
record: subdomain
```

## Crontab

Currently to make sure, that your IP is updated on a regular basis, you should add the execution to your Home Assistant crontab.

This will be improved in future versions.

Login in using SSH Addon and do the following;

```shell script
(crontab -l 2>/dev/null; echo "*/30 * * * * ha ad run $(ha ad list | egrep "slug: ([0-9a-z]+_cloudflare_dyndns)" | cut -d ":" -f2) 2>&1 >> /var/log/cloudflare_dyndns.log | crontab -
```
