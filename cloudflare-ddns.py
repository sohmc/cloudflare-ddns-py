import json
import requests
import os.path

# Configuration goes here
cf_api_token = ''
cf_email = ''

# zone name that contains your subdomain A RECORD (e.g. example.com, wikipedia.org, etc.)
cf_zone = 'example.com'

# subdomain that you are updating
cf_sub = 'homenetwork'


# Do NOT append an ending slash here!
cf_api_url = 'https://api.cloudflare.com/client/v4'


def config():
    print "The information provided to this configuration "
    print "is used to obtain information about your domain "
    print "and update the specified records accordingly."
    print ""
    print "Keep in mind that this information is not validated"
    print "or checked for accuracy prior to running."
    print ""

    cf_config = {"email":     "",
                 "api_key":   "",
                 "zone_name": "",
                 "subdomain": ""}

    while (cf_config['email'] == ""):
        print "Please type in the e-mail address associated with CloudFlare: "
        cf_config['email'] = input("> ")
        print ""

    while (cf_config['api_key'] == ""):
        print "This application only supports GLOBAL API keys."
        print "User Service keys are an enterprise feature and this"
        print "developer is a freeloader and can't test it."
        print "Please copy and paste your GLOBAL API KEY:"
        cf_config['api_key'] = input("> ")
        print ""

    while (cf_config['zone_name'] == ""):
        print "Type the zone name, or domain name, you are accessing."
        print "For foobar.example.com, type here \"example.com\", without"
        print "quotes."
        cf_config['zone_name'] = input("> ")
        print ""

    while (cf_config['subdomain'] == ""):
        print "Type the subdomain record you wnat to update."
        print "For foobar.example.com, type here \"foobar\", without"
        print "quotes."
        cf_config['zone_name'] = input("> ")
        print ""

    print cf_config


def get_zone_id(zone_name):
    data = {'X-Auth-Email': cf_email, 
            'X-Auth-Key': cf_api_token,
            'Content-Type': 'application/json'}

    r = requests.get(cf_api_url + '/zones', headers=data)
    print r.url
    print json.dumps(r.json(), indent=4, sort_keys=True)


