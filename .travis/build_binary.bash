#!/bin/bash
BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.bin
DIST_FILE=cloudflare-ddns

set -ev
pip install awscli
pip install pyinstaller

sudo chown -Rv $USER:$GROUP ~/.cache/pip/wheels

pyinstaller --log-level=DEBUG --onefile ./cloudflare-ddns.py

if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    DIST_FILE=cloudflare-ddns.exe
    BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.exe
fi

if [[ -f ./dist/${DIST_FILE} ]]; then
    cp ./dist/cloudflare-ddns ./dist/${BIN_NAME}
    aws s3 cp \
        ./dist/${BIN_NAME} \
        s3://${AWS_TRAVIS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/ \
        --acl public-read
fi

ls -lR
