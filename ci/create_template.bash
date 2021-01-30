#!/bin/bash -u
TEMP_FILE=./cf_ddns.conf
SED_OPTIONS='-i'

cd ci/

if [[ -f ./cf_ddns.conf ]]; then
    rm ${TEMP_FILE}
fi

if [[ ${TRAVIS_OS_NAME} == "macos-latest" ]]; then
    echo "Setting sed options for osx"
    SED_OPTIONS='-i "" -e '
fi

echo "Creating copy of the template..."
cp ./cf_ddns-template.conf ${TEMP_FILE}

if [[ -z "${API_KEY}" ]]; then
    echo "API_KEY not set.  Exiting..."
    exit 1;
else
    echo "Adding API Key..."
    sed ${SED_OPTIONS} "s/\$API_KEY/${API_KEY}/" ${TEMP_FILE}
fi;

if [[ -z "${SUBDOMAIN}" ]]; then
    echo "SUBDOMAIN not set.  Exiting..."
    exit 1;
else
    echo "Adding Sub-domain..."
    sed ${SED_OPTIONS} "s/\$SUBDOMAIN/${SUBDOMAIN}/" ${TEMP_FILE}
fi;

if [[ -z "${ZONE}" ]]; then
    echo "ZONE not set.  Exiting..."
    exit 1;
else
    echo "Adding Zone..."
    sed ${SED_OPTIONS} "s/\$ZONE/${ZONE}/" ${TEMP_FILE}
fi;


if [[ -z "${EMAIL}" ]]; then
    echo "EMAIL not set.  Removing..."
    sed ${SED_OPTIONS} "/\$EMAIL/d" ${TEMP_FILE}
else
    echo "Adding e-mail..."
    sed ${SED_OPTIONS} "s/\$EMAIL/${EMAIL}/" ${TEMP_FILE}
fi;

