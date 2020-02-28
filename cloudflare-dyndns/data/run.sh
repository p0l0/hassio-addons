#!/usr/bin/env bashio

APITOKEN=""
APIKEY=""
APIEMAIL=""
DNSZONE_NAME=$(bashio::config 'domain')
DNSZONE_RECORD=$(bashio::config 'record')
SLEEP_TIME=$(bashio::config 'retry_interval')
LOG_LEVEL=$(bashio::config 'log_level' | tr '[:upper:]' '[:lower:]')

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

echo -e "{\n" \
    "\"cloudflare\": {\n" > /app/config.json


if [ "${APITOKEN}" != "" ]; then
    echo -e "\"apiToken\": \"${APITOKEN}\"\n" >> /app/config.json
elif [ "${APIKEY}" != "" ]; then
    echo -e "\"apiKey\": \"${APIKEY}\",\n" \
        "\"email\": \"${APIEMAIL}\"\n" >> /app/config.json
fi

echo -e "},\n" \
    "\"dnsZone\": {\n" \
    "\"name\": \"${DNSZONE_NAME}\",\n" \
    "\"record\": \"${DNSZONE_RECORD}\"\n" \
    "}\n" \
    "}" >> /app/config.json

chmod 0600 /app/config.json

LL=1
case $LOG_LEVEL in
    "fatal") LL=1;;
    "error") LL=2;;
    "warn" ) LL=3;;
    "info" ) LL=4;;
    "debug") LL=5;;
esac

while true; do
    /app/cloudflare-dyndns -c /app/config.json -ll $LL

    sleep ${SLEEP_TIME}
done
