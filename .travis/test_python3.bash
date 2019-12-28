#!/bin/bash

set -ev

echo "API Token Test"
export API_KEY=$API_TOKEN

echo "Building template..."
bash .travis/create_template.bash

echo "Running script..."
python cloudflare-ddns.py -f -c .travis/cf_ddns.conf


echo "Global API Key Test"
export API_KEY=$GLOBAL_API_KEY
export EMAIL=$CF_EMAIL

echo "Building template..."
bash .travis/create_template.bash

echo "Running script..."
python cloudflare-ddns.py -f -c .travis/cf_ddns.conf
