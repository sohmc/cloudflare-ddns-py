import json
import requests

# Configuration goes here
cf_api_token = ''
cf_email = ''

# zone name that contains your subdomain A RECORD (e.g. example.com, wikipedia.org, etc.)
cf_zone = 'example.com'

# subdomain that you are updating
cf_sub = 'homenetwork'


# Do NOT append an ending slash here!
cf_api_url = 'https://api.cloudflare.com/client/v4'

