# cloudflare-ddns-py

Got a [CloudFlare](https://www.cloudflare.com)-managed domain that you
want to update with your dynamically changing IP address?

`cloudflare-ddns` will update your `A RECORD` on CloudFlare using their
latest API, version 4.0.  [Previous project](https://bitbucket.org/sohmc/cloudflare-ddns-git)
uses API 1.0, which [CloudFlare is retiring on November 9th,
2016](https://blog.cloudflare.com/sunsetting-api-v1-in-favor-of-cloudflares-current-client-api-api-v4/).


## Requirements

In order to run this script, you'll need:
* Python 2.7.x (This script was developed on 2.7.6)
* [`requests` library](http://docs.python-requests.org/en/master/), installable using `pip`

In order to make use of this script, you will also need to obtain a
CloudFlare API key.  This is obtained by logging into CloudFlare and
then clicking "[My Settings](https://www.cloudflare.com/a/account/my-account)", 
which is located under the User menu on the top right corner of the 
page.


## License

This project is licensed using the [GNU Public License
3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).  I also have a very
strict "It works for me, YMMV" motto.  Feel free to submit your bug
reports and feature requests but support is not guarenteed, implied, or
explictly offered.


## Pull Requests

Pull requests are encouraged onto the `staging` branch.  The `master`
branch is reserved for releases, except the initial commits.
