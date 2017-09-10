#!/bin/sh
# Dynamic IP Updater for Cloudflare Domains
# Wrapper Script
# Version 0.1
# Licensed via GPL v3
# 
#


# Which Python -- Leave commented if you want to use the one
# in your path
python=/usr/bin/python2

# Location of the updater script
script=/path/to/cloudflare-ddns-py/cloudflare-ddns.py

# Location of the config file -- Leave commented if you want
# to use the default location (~/.config/.cf_ddns.conf) or 
# you have configured the script directly
# config=

# Location of the logfile
logfile=~/cloudflare.log

# =================

date 

if [ -z "$python" ]; then
    python=`which python`
fi

cmd="${python} ${script}"

if [ ! -z "$config" ]; then
    cmd="${cmd} -c ${config}"
fi

echo Built Command:
echo ${cmd}

echo Running ...

${cmd}
