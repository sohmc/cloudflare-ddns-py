#!/bin/bash
BIN_NAME=./dist/cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.bin

if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.exe
fi

# S3_URI=https://s3.amazonaws.com/${AWS_TRAVIS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/${BIN_NAME}

set -ev

# echo "Getting binary from S3..."
# curl -v $S3_URI -o $BIN_NAME

chmod +x ${BIN_NAME}
ls -lR

echo "API Token Test"
export API_KEY=$API_TOKEN

echo "Building template..."
bash .travis/create_template.bash

echo "Running script..."
${BIN_NAME} -f -c .travis/cf_ddns.conf


echo "Global API Key Test"
export API_KEY=$GLOBAL_API_KEY
export EMAIL=$CF_EMAIL

echo "Building template..."
bash .travis/create_template.bash

echo "Running script..."
${BIN_NAME} -f -c .travis/cf_ddns.conf
