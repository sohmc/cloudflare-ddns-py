#!/bin/bash
BUILD_ID=GITHUB_RUN_NUMBER

echo "s3 cp from ./dist/${BIN_NAME} to"
echo "  s3://${AWS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/"

"${AWS_CMD}" s3 cp \
    ./dist/${BIN_NAME} \
    s3://${AWS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/ \
    --acl public-read
