#!/bin/bash
AWSCLI_VERSION=2.0.56
AWS_CMD=/usr/local/bin/aws

mkdir -p ~/.cache/pip/wheels

set -ev

echo "Installing AWS CLI v. ${AWSCLI_VERSION} for OS ${TRAVIS_OS_NAME} on arch ${TRAVIS_CPU_ARCH}"

if [[ $TRAVIS_OS_NAME == "linux-latest" ]]; then
    if [[ $TRAVIS_CPU_ARCH == "amd64" ]]; then 
        DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip"
    elif [[ $TRAVIS_CPU_ARCH == "arm64" ]]; then 
        DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${AWSCLI_VERSION}.zip"
    fi

    curl ${DOWNLOAD_URL} -o awscliv2.zip
    unzip awscliv2.zip
    sudo ./aws/install
elif [[ $TRAVIS_OS_NAME == "macos-latest" ]]; then
    curl "https://awscli.amazonaws.com/AWSCLIV2-${AWSCLI_VERSION}.pkg" \
        -o "AWSCLIV2.pkg"
    sudo installer -pkg awscliv2.pkg -target /
elif [[ $TRAVIS_OS_NAME == "windows-latest" ]]; then
    echo "Installing via choco..."
    choco install awscli
    AWS_CMD="/c/Program Files/Amazon/AWSCLIV2/aws.exe"
    echo ${AWS_CMD}
fi

ls -lR "${AWS_CMD}"

echo "Testing for AWS cli"
"${AWS_CMD}" --version
