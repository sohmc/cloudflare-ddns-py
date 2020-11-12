#!/bin/bash
BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.bin
DIST_FILE=cloudflare-ddns
AWSCLI_VERSION=2.0.56
AWS_CMD=aws

mkdir -p ~/.cache/pip/wheels

set -ev

echo "Installing AWS CLI v. ${AWSCLI_VERSION} for OS ${TRAVIS_OS_NAME} on arch ${TRAVIS_CPU_ARCH}"

if [[ $TRAVIS_OS_NAME == "linux" ]]; then
    if [[ $TRAVIS_CPU_ARCH == "amd64" ]]; then 
        DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip"
    elif [[ $TRAVIS_CPU_ARCH == "arm64" ]]; then 
        DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${AWSCLI_VERSION}.zip"
    fi

    curl ${DOWNLOAD_URL} -o awscliv2.zip
    unzip awscliv2.zip
    sudo ./aws/install
elif [[ $TRAVIS_OS_NAME == "osx" ]]; then
    curl "https://awscli.amazonaws.com/AWSCLIV2-${AWSCLI_VERSION}.pkg" \
        -o "AWSCLIV2.pkg"
    sudo installer -pkg awscliv2.pkg -target /
elif [[ $TRAVIS_OS_NAME == "windows" ]]; then
    echo "Installing via choco..."
    choco install awscli
    AWS_CMD=/c/Program\ Files/Amazon/AWSCLIV2/aws.exe
fi

echo "Testing for AWS cli"
${AWS_CMD} --version


echo "Installing pyinstaller"
pip3 install pyinstaller

echo chowning pip wheels directory
chown -Rv $USER:$GROUP ~/.cache/pip/wheels

pyinstaller --log-level=DEBUG --onefile ./cloudflare-ddns.py

if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    DIST_FILE=cloudflare-ddns.exe
    BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.exe
fi

if [[ -f ./dist/${DIST_FILE} ]]; then
    cp ./dist/cloudflare-ddns ./dist/${BIN_NAME}
    ${AWS_CMD} s3 cp \
        ./dist/${BIN_NAME} \
        s3://${AWS_TRAVIS_DEPLOY_BUCKET}/cloudflare_ddns/${BUILD_ID}/ \
        --acl public-read
fi

