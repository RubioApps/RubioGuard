# RubioGuard
Advanced Squid Proxy Cache with a redirect of the traffic to TOR

## Purpose

This is a tutorial to explain how to build a complex configuration for a Squid Proxy Server that includes an optional redirect of the traffic to Privoxy and TOR
This configuration CAN ONLY be used for personnal purposes in a domestic network, never a public one.

###**IMPORTANT NOTICE:**
.The use of a Man-in-the-middle might be illegal in some countries
.I decline any responsibility about the use of the following configuration and about any vulnerability devired from the third party software suggested in this tutorial

## Requirements

This is the list of needed software needed to build up the complete setup:

- Squid Proxy Cache 5.7 or higher. More info at [Squid PRoxy](http://www.squid-cache.org/)
- Privoxy filtering content Server. More info at [Privoxy](https://www.privoxy.org/)
- TOR. More info at [TOR](https://packages.ubuntu.com/jammy/tor)
- C-ICAP Server. More info at [C-ICAP](https://c-icap.sourceforge.net/)
- EasyRSA. More info at [OpenVPN](https://github.com/OpenVPN/easy-rsa)

If you decide to disable any option across the following tutorial, you could not use the related service or server, and its installation would be not mandatory.




