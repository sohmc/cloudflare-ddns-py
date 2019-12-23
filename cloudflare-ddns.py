"""
cloudflare-ddns.py -- Update your dynamic IP address automatically using
                      CloudFlare's latest API version 4.0
Version 1.1

Written by Michael Soh
Licensed via GPL 3.0
https://github.com/sohmc/cloudflare-ddns-py
"""

import json
import requests
import os.path
import sys
import getopt
import logging


# Configuration goes here
logging.basicConfig(format='%(asctime)s %(process)d %(levelname)s %(message)s',
        level=logging.DEBUG)
cf_config_file = os.path.expanduser('~/.config/.cf_ddns.conf')
logging.debug('Default config file location: %s', cf_config_file)

cf_config = dict()

# If you do not want to use a config file, you may manually
# set the configuration here.  Uncomment the following lines
# and set the parameters with the values necessary.  'email'
# is only required if you are using the GLOBAL API Key.  If
# you are using an API token, you MUST leave email commented
# out.
#cf_config['api_token'] = 'abcdef1234567890'
#cf_config['email']     = 'me@example.com'
#cf_config['zone']      = 'example.com'
#cf_config['subdomain'] = 'foobar

# Do NOT append an ending slash here!
cf_api_url = 'https://api.cloudflare.com/client/v4'
logging.debug('API URL set: %s ', cf_api_url);

# Default flags
force_update = False
run_config = False


def print_usage():
    print("usage: " + sys.argv[0] + " [-f] [-c <config_file>]")
    print("""
-f                   Force IP address update, even if the record is the same
                     as the current IP address.

-c <config_file>     Run using the config file, if provided.  If the config
                     file is empty or does not exist, the config will run 
                     and save values in the specified file.  The script will
                     run without arguments when the config file is found 
                     at """ + cf_config_file)
    sys.exit(2)


# Sets the configuration for the script
def config():
    print("The information provided to this configuration ")
    print("is used to obtain information about your domain ")
    print("and update the specified records accordingly.")
    print("")
    print("Keep in mind that this information is not validated")
    print("or checked for accuracy prior to running.")
    print("")

    print("This application supports both Global API keys as well as")
    print("the newer and more secure API Tokens.")
    print("User Service keys are an enterprise feature and this")
    print("developer is a freeloader and can't test it.")
    print("")

    print("Please copy and paste your Global API Key or API Token:")
    cf_config['api_key'] = input("> ")
    print("")
   
    print("Global API Keys REQUIRE the e-mail address associated with")
    print("the key.  If you are using a token, leave this blank.")
    print("Please type in the e-mail address associated with CloudFlare, if using a Global Key: ")
    email = input("> ")

    if ('email' != ""):
        cf_config['email'] = input("> ")

    print("")


    print("Type the zone name, or domain name, you are accessing.")
    print("For foobar.example.com, type here \"example.com\", without")
    print("quotes.")
    cf_config['zone'] = input("> ")
    print("")

    print("Type the subdomain record you wnat to update.")
    print("For foobar.example.com, type here \"foobar\", without")
    print("quotes.")
    cf_config['subdomain'] = input("> ")
    print("")

    logging.debug('Writing configuration into outfile %s', outfile);
    with open(cf_config_file, 'w') as outfile:
        json.dump(cf_config, outfile, sort_keys=True, indent=2)


# sets headers for all requests
def cf_headers():
    cf_headers = {}

    if 'email' in cf_config:
        cf_headers = {'X-Auth-Email': cf_config['email'], 
                      'X-Auth-Key': cf_config['api_key'],
                      'Content-Type': 'application/json'}
    else:
        cf_headers = {'Authorization': 'Bearer ' + cf_config['api_key'],
                      'Content-Type': 'application/json'}

    logging.debug('Setting CloudFlare headers: %s', cf_headers)
    return cf_headers

# Gets the zone_id for the domain name, required for looking
# up the record, and setting the IP address, of the subdomain
def get_zone_id(zone_name):
    r_data = {'name': zone_name,
              'status': 'active'}
    request_url = cf_api_url + '/zones';

    logging.debug('REQUEST GET: %s', request_url)
    logging.debug('r_data being: %s', r_data)

    r = requests.get(request_url, headers=cf_headers(), params=r_data)
    cf_response = r.json()

    ret_val = None
    if ((cf_response['success'] == True) and
            (cf_response['result'][0]['name'] == zone_name)):
        cf_config['zone_id'] = str(cf_response['result'][0]['id'])
        logging.debug('Got zone id: ' + cf_config['zone_id'])
    elif (len(cf_response['errors']) > 0):
        print("CloudFlare returned error(s): ")
        print(cf_response['errors'])
    elif (cf_response['result_info']['count'] == 0):
        print("CloudFlare returned no results.")
    
    #print json.dumps(cf_response['result'][0], indent=4, sort_keys=True)
    return ret_val


# Gets the subdomain_id of the subdomain, required for setting the IP
# address.
def get_subdomain_id(subdomain):
    fqsubdomain = subdomain + '.' + cf_config['zone']
    r_data = {'name': fqsubdomain,
              'type': 'A'}

    r = requests.get(cf_api_url + '/zones/' + cf_config['zone_id'] +
            '/dns_records', headers=cf_headers(), params=r_data)
    cf_response = r.json()

    if ((cf_response['success'] == True) and
            (cf_response['result'][0]['name'] == fqsubdomain)):
        cf_config['domain_id'] = str(cf_response['result'][0]['id'])
        cf_config['domain_record'] = str(cf_response['result'][0]['content'])
        logging.debug('Got domain id: ' + cf_config['domain_id'] + ' :: ' + cf_config['domain_record'])
    elif (len(cf_response['errors']) > 0):
        print("CloudFlare returned error(s): ")
        print(cf_response['errors'])
    elif (cf_response['result_info']['count'] == 0):
        print("CloudFlare returned no results.")


# Updates the IP address of the subdomain record.
def update_cf_record():
    fqsubdomain = cf_config['subdomain'] + '.' + cf_config['zone']
    r_data = {'id': cf_config['domain_id'],
              'content': cf_config['current_dyip'],
              'name': fqsubdomain,
              'type': 'A'}
    
    r = requests.put(cf_api_url + '/zones/' + cf_config['zone_id'] +
            '/dns_records/' + cf_config['domain_id'],
            headers=cf_headers(), data=json.dumps(r_data))
    cf_response = r.json()

    if ((cf_response['success'] == True) and (cf_response['result']['id'] == cf_config['domain_id'])):
        return True
    elif (len(cf_response['errors']) > 0):
        print("CloudFlare returned error(s): ")
        print(cf_response['errors'])
    elif (cf_response['result_info']['count'] == 0):
        print("CloudFlare returned no results.")

    return False


# Gets the current IP address, courtesy of ipify.org
def get_current_dyip():
    r_params = {'format': 'json'}
    r = requests.get('http://api.ipify.org', params=r_params)
    cf_config['current_dyip'] = str(r.json()['ip'])


# Procedure to show the current CloudFlare DNS record and 
# the current IP address.
def update():
    print("CloudFlare record:  " + cf_config['domain_record'])
    print("Current dynamic IP: " + cf_config['current_dyip'])

    if (update_cf_record() == True):
        print("CloudFlare record updated.")



# =-=-=-=-=-=-=-=-=-=- MAIN -=-=-=-=-=-=-=-=-=-= #

# Check command for any parameters
if (len(sys.argv) > 1):
    try:
        opts, args = getopt.getopt(sys.argv[1:], "fc:")
    except getopt.GetoptError:
        print_usage()

    for o, a in opts:
        # Use provided config file
        if (o == '-c'):
            run_config = True
            if (a != ""):
                cf_config_file = a

            logging.debug('Using config ' + cf_config_file);
        # Force update of IP address, even if there is no change
        elif (o == '-f'):
            force_update = True
        else:
            print_usage()


# read the configuration or force config if config file is empty
if ('api_token' in cf_config):
    logging.info('Configuration set within the script.')
    logging.debug(cf_config);
elif (os.path.isfile(cf_config_file) or (run_config == True)):
    try:
        logging.debug('Attempting to read config: ' + cf_config_file)
        with open(cf_config_file) as datafile:
            cf_config = json.load(datafile)
            logging.debug('Config: %s', cf_config)
    except:
        if (run_config):
            config()
else:
    config();


if ((not 'api_key' in cf_config) 
    or (not 'zone' in cf_config) 
    or (not 'subdomain' in cf_config)):
        print("There was a problem parsing your configuration.  Please ensure that you")
        print("have either populated the configuration variables directly into this ")
        print("script or your config file is in a readable and accessible location.")
        print("This script is looking in the following file: ")
        print("     " + cf_config_file)
        exit(3)

# All config work is done.  Let's actually check all the things.

get_zone_id(cf_config['zone'])
get_subdomain_id(cf_config['subdomain'])
get_current_dyip()

# Check if the current IP is different from the registered IP
if (cf_config['current_dyip'] == cf_config['domain_record']):
    print("CloudFlare record matches current dynamic IP address.")
    if (force_update): 
        print("-f flag received!  Forcing update.")
        update()
    else:
        print("Exiting with no further action.")
else:
    update()
