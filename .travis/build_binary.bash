#!/bin/bash
BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.bin
DIST_FILE=cloudflare-ddns

mkdir -p ~/.cache/pip/wheels

set -ev


echo "Installing pyinstaller"
pip install pyinstaller

echo chowning pip wheels directory
chown -Rv $USER:$GROUP ~/.cache/pip/wheels

pyinstaller --log-level=DEBUG --onefile ./cloudflare-ddns.py

if [[ $TRAVIS_OS_NAME == "windows-latest" ]]; then
    DIST_FILE=cloudflare-ddns.exe
    BIN_NAME=cloudflare-ddns-${TRAVIS_OS_NAME}-${TRAVIS_CPU_ARCH}.exe
fi

if [[ -f ./dist/${DIST_FILE} ]]; then
    cp ./dist/cloudflare-ddns ./dist/${BIN_NAME}
fi

echo Binary copied: 
ls -l ./dist/${BIN_NAME}

echo "::set-output name=BIN_NAME::${BIN_NAME}"
