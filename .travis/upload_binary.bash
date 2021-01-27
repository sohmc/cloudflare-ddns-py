#!/bin/bash
AWS_CMD=/usr/local/bin/aws
BUILD_ID=GITHUB_RUN_NUMBER

set -ev

if [[ $TRAVIS_OS_NAME == "windows-latest" ]]; then
    AWS_CMD="/c/Program Files/Amazon/AWSCLIV2/aws.exe"
    echo ${AWS_CMD}
    ls -lR "${AWS_CMD}"
fi

echo "s3 cp from ./dist/${BIN_NAME} to"
echo "  s3://${AWS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/"

"${AWS_CMD}" s3 cp \
    ./dist/${BIN_NAME} \
    s3://${AWS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/ \
    --acl public-read
