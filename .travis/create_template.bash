#!/bin/bash -u
TEMP_FILE=./cf_ddns.conf

cd .travis/

if [[ -f ./cf_ddns.conf ]]; then
    rm ${TEMP_FILE}
fi

echo "Creating copy of the template..."
cp ./cf_ddns-template.conf ${TEMP_FILE}

if [[ -z "${API_KEY}" ]]; then
    echo "API_KEY not set.  Exiting..."
    exit 1;
else
    echo "Adding API Key..."
    sed -i "s/\$API_KEY/${API_KEY}/" ${TEMP_FILE}
fi;

if [[ -z "${SUBDOMAIN}" ]]; then
    echo "SUBDOMAIN not set.  Exiting..."
    exit 1;
else
    echo "Adding Sub-domain..."
    sed -i "s/\$SUBDOMAIN/${SUBDOMAIN}/" ${TEMP_FILE}
fi;

if [[ -z "${ZONE}" ]]; then
    echo "ZONE not set.  Exiting..."
    exit 1;
else
    echo "Adding Zone..."
    sed -i "s/\$ZONE/${ZONE}/" ${TEMP_FILE}
fi;


if [[ -z "${EMAIL}" ]]; then
    echo "EMAIL not set.  Removing..."
    sed -i "/\$EMAIL/d" ${TEMP_FILE}
else
    echo "Adding e-mail..."
    sed -i "s/\$EMAIL/${EMAIL}/" ${TEMP_FILE}
fi;

