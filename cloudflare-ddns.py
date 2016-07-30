import json
import requests
import os.path


cf_config = {"email":     "",
             "api_key":   "",
             "zone_name": "",
             "subdomain": ""}

# Configuration goes here
cf_config_file = '~/.config/.cf_ddns.conf'



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
    r_headers = {'X-Auth-Email': cf_config['email'], 
                 'X-Auth-Key': cf_config['api_token'],
                 'Content-Type': 'application/json'}

    r_data = {'name': 'example.com',
              'status': 'active'}

    r = requests.get(cf_api_url + '/zones', headers=r_headers, data=r_data)
    cf_response = r.json()

    ret_val = None
    if ((cf_response['success'] == True) and
            (cf_response['result'][0]['name'] == zone_name)):
        ret_val = cf_config['zone_id'] = cf_response['result'][0]['id']
    elif (len(cf_response['errors']) > 0):
        print "CloudFlare returned error(s): "
        print cf_response['errors']
    elif (cf_response['result_info']['count'] == 0):
        print "CloudFlare returned no results."
    
    #print json.dumps(cf_response['result'][0], indent=4, sort_keys=True)
    return ret_val


# =-=-=-=-=-=-=-=-=-=- MAIN -=-=-=-=-=-=-=-=-=-= #
cf_config['zone_id'] = get_zone_id('mikesoh.com')
