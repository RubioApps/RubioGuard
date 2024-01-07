# Filtering

If you have followed the previous steps, you know that we have now defined the domains we want to bump, the pools, the size of the memory and the refresh policy.

But, **what about a filter?** What if we want to ban the access to the websites about gambling or sects from home?

Here, Squid Proxy can be configured to work together with other mechanisms and provide a good filter of the content you receive into your browser.

There is several methods to proceed, some are simple, some are complex.

## URL Rewriting (optional)

When you point to a website that might be forbidden for my family, I use 3 methods to rewrite the URL

__Method 1__: Use NextDNS filter https://my.nextdns.io . This is my case, by I pay for it to customize it.

__Method 2__: Use SquidGuard to filter

This method is very slow, based on Berkely databases with a very obsolete list of banned websites.
I installed for a while, but it does not work properly for HTTPS (it only filters plain text from non-secured HTTP)

You can read further [here](https://en.wikipedia.org/wiki/SquidGuard).

If you decided to install it, the way it can be bridged with Squid Proxy is to add the following lines to yor squid.conf

```
url_rewrite_program /usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf
url_rewrite_children 5 startup=1 idle=1
url_rewrite_access allow BROWSERS
url_rewrite_access deny all
```

__Method 3__: Use service of ICAP Server to filter

I use this method in addition to the Method 1 (NextDNS) because it allows to scan ALL THE TRAFFIC with the very efficient Antivirus ClamAV for Linux distros.

This means that I do not need to have an Antivirus installed on each PC Client, but a centralized one running on the Squid Server would be enough.

__NOTE__: 

To run ClamAV as a background service has a very high cost in terms of memory. It consumes roughtly 1GB.
Therefore, it depends on your installed RAM Memory. 

To use the Method 3 (Scan all the traffic), I proceed by using 2 combined services: 

- [SquidClamav](https://squidclamav.darold.net/)
- [C-ICAP Server](https://squidclamav.darold.net/)

Please read the installation of both services at their websites. In the case of C-ICAP I have compiled it from the scratch.
Once you have setup both, you can bridge them to Squid by adding the following lines to the squid.conf

```
#Enable C-ICAP service
icap_enable on
icap_send_client_ip on
icap_send_client_username on
icap_client_username_encode off
icap_client_username_header X-Client-Username
icap_persistent_connections on
icap_preview_enable on
icap_preview_size 1024

# Squidclamav
icap_service CLAMAV_REQ reqmod_precache icap://localhost:1344/squidclamav bypass=on routing=on
adaptation_access CLAMAV_REQ allow BROWSERS
adaptation_access CLAMAV_REQ deny all
icap_service CLAMAV_RESP respmod_precache icap://localhost:1344/squidclamav bypass=on routing=on
adaptation_access CLAMAV_RESP allow BROWSERS
adaptation_access CLAMAV_RESP deny all

```

Please be sure that C-ICAP runs on the localhost port 1344. Otherwise, please modify the previous lines to match the C-ICAP configuration.
