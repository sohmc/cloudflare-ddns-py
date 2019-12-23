# cloudflare-ddns-py 

[![Build Status](https://travis-ci.com/sohmc/cloudflare-ddns-py.svg?branch=master)](https://travis-ci.com/sohmc/cloudflare-ddns-py)

**Current Version: 1.1 (Released 2019-Dec-23)**

Got a [CloudFlare](https://www.cloudflare.com)-managed domain that you
want to update with your dynamically changing IP address?

`cloudflare-ddns` will update your `A RECORD` on CloudFlare using their
latest API, version 4.0.  [Previous project](https://bitbucket.org/sohmc/cloudflare-ddns-git)
uses API 1.0, which [CloudFlare is retiring on November 9th,
2016](https://blog.cloudflare.com/sunsetting-api-v1-in-favor-of-cloudflares-current-client-api-api-v4/).


## Requirements

In order to run this script, you'll need:
* Python 3 (This script was developed using Python 3.6.8.  It _should_
  work with newer versions of Python 3, but there is no guarentee.)
* [`requests` library](http://docs.python-requests.org/en/master/), installable using `pip`

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
* Include: All zones

Yes, access to all zones is needed at this time.  Please see issue
[#10](https://github.com/sohmc/cloudflare-ddns-py/issues/10) for
details.


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
3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).  I also have a very
strict "It works for me, YMMV" motto.  Feel free to submit your bug
reports and feature requests but support is not guarenteed, implied, or
explictly offered.


## Pull Requests

Pull requests are encouraged onto the `staging` branch.  The `master`
branch is reserved for releases.
