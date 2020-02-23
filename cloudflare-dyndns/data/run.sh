#!/usr/bin/env bashio

APITOKEN=""
APIKEY=""
APIEMAIL=""
DNSZONE_NAME=$(bashio::config 'domain')
DNSZONE_RECORD=$(bashio::config 'record')
SLEEP_TIME=$(bashio::config 'retry_interval')

if bashio::config.exists 'api_token'; then
    bashio::log.info "Use CloudFlare token"
    APITOKEN=$(bashio::config 'api_token')
elif bashio::config.exists 'api_key' && bashio::config.exists 'email'; then
    bashio::log.info "Use CloudFlare API Key"
    APIKEY=$(bashio::config 'api_key')
    APIEMAIL=$(bashio::config 'email')
else
    bashio::log.error "Please provide api_token or api_key/email"
    return 1
fi

echo -e "\"cloudflare\": {\n" > /app/config.json
chmod 0600 /app/config.json

if [ "${APITOKEN}" != "" ]; then
    echo -e "\"apiToken\": \"${APITOKEN}\"\n" >> /app/config.json
elif [ "${APIKEY}" != "" ]; then
    echo -e "\"apiKey\": \"${APIKEY}\",\n" \
        "\"email\": \"${APIEMAIL}\"\n" >> /app/config.json
fi

echo -e "},\n" \
    "\"dnsZone\": {\n" \
    "\"name\": \"${DNSZONE_NAME}\",\n" \
    "\"record\": \"${DNSZONE_RECORD}\",\n" \
    "}" >> /app/config.json

while true; do
    /app/cloudflare-dyndns -c /app/config.json

    sleep ${SLEEP_TIME}
done
