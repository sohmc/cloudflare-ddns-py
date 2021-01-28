# cloudflare-ddns-py 

![Cloudflare DDNS](https://github.com/sohmc/cloudflare-ddns-py/workflows/Cloudflare%20DDNS/badge.svg)

**Current Version: 1.2 (Released 2020-Nov-11)**

Got a [CloudFlare](https://www.cloudflare.com)-managed domain that you
want to update with your dynamically changing IP address?

`cloudflare-ddns` will update your `A RECORD` on CloudFlare using their
latest API, version 4.0.  Use this to update your home IP address, AWS
instances, or other IP addresses that are not static.

## Requirements

In order to run this script, you'll need:
* Python 3 (This script was developed using Python 3.6.8, with Travis-CI 
  testing it against 2.9.0.)
* [`requests` library](http://docs.python-requests.org/en/master/), installable using `pip`

Or just download one of the [pre-build binaries](https://github.com/sohmc/cloudflare-ddns-py/releases).

In order to make use of this script, you will also need to obtain a
CloudFlare API key.  This is obtained by logging into CloudFlare and
then clicking "[API
Tokens](https://dash.cloudflare.com/profile/api-tokens)" under "My
Profile",  which is located under the User menu on the top right corner 
of the page.

This script supports both the Global API key as well as the newer and
more secure API Token.  When creating an API Token, you must give it the
following rights:
* Zone.Zone: Read
* Zone.DNS: Edit
* Include: One Zone


## Usage
```
usage: cloudflare-ddns.py [-f] [-c <config_file>]

-f                   Force IP address update, even if the record is the same
                     as the current IP address.

-c <config_file>     Run using the config file, if provided.  If the config
                     file is empty or does not exist, the config will run 
                     and save values in the specified file.  The script will
                     run without arguments when the config file is found 
                     at ~/.config/.cf_ddns.conf
```

## License

This project is licensed using the [GNU Public License
3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
