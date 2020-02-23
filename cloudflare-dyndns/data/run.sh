#!/usr/bin/env bashio

APITOKEN=""
APIKEY=""
APIEMAIL=""
DNSZONE_NAME=$(bashio::config 'dnsZone.name')
DNSZONE_RECORD=$(bashio::config 'dnsZone.record')

if bashio::config.exists 'cloudflare.apiToken'; then
    bashio::log.info "Use CloudFlare token"
    APITOKEN=$(bashio::config 'cloudflare.apiToken')
else if bashio::config.exists 'cloudflare.apiKey' && bashio::config.exists 'cloudflare.email'; then
    bashio::log.info "Use CloudFlare API Key"
    APIKEY=$(bashio::config 'cloudflare.apiKey')
    APIEMAIL=$(bashio::config 'cloudflare.email')
else
    bashio::log.error "Please provide apiToken or apiKey/email"
    return 1
fi

echo -e "\"cloudflare\": {\n" > /app/config.json
chmod 0600 /app/config.json

if [ "${APITOKEN}" != "" ]; then
    echo -e "\"apiToken\": \"${APITOKEN}\"\n" >> /app/config.json
else if [ "${APIKEY}" != "" ]; then
    echo -e "\"apiKey\": \"${APIKEY}\",\n" \
        "\"email\": \"${APIEMAIL}\"\n" >> /app/config.json
fi

echo -e "},\n" \
    "\"dnsZone\": {\n" \
    "\"name\": \"${DNSZONE_NAME}\",\n" \
    "\"record\": \"${DNSZONE_RECORD}\",\n" \
    "}" >> /app/config.json

/app/cloudflare-dyndns -c /app/config.json
