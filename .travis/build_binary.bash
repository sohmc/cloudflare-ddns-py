#!/bin/bash

set -ev
pip install awscli
pip install pyinstaller
pyinstaller --onefile ./cloudflare-ddns.py
export BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.bin
cp ./dist/cloudflare-ddns ./dist/${BIN_NAME}
ls -lR
aws s3 cp ./dist/${BIN_NAME} s3://${AWS_TRAVIS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/ --dryrun
