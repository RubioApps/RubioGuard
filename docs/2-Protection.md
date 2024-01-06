# Protection

## Authorization to Squid

You can restrict the access to the Squid Proxy Server
To create a password, type this. Replace [USERNAME] with your choice

```
htpasswd -c /etc/squid/.passwd [USERNAME]
chown proxy:proxy /etc/squid/.passwd
chmod 0640 /etc/squid/.passwd
```

Once you have created the password, at the begining of the squid.conf you'll find this:

```
auth_param basic program  /usr/lib/squid/basic_ncsa_auth /etc/squid/.passwd
auth_param basic children 5 startup=5 idle=1
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 24 hours
auth_param basic casesensitive off
acl AUTHENTICATED proxy_auth REQUIRED
```

Remove it if you do not want to use a password to access to the Proxy Server


## Authorization to the Cache Manager

If you want to use the cache manager from Squid, you might use a password. This extension of Squid Proxy server allows to collect the statistics of the server.
In order to preserve the privacy of the members of your family (do not forget this configuration is only for domestic purposes), I recommend to protect it with a password.

```
cachemgr_passwd [PASSWORD FOR THE CACHE MANAGER] all
```
For further information about the Cache Manager, please visit [Ubuntu Docs](https://manpages.ubuntu.com/manpages/trusty/man8/cachemgr.cgi.8.html)



## Access Control List (ACL)

Here I have defined the shortnames of the rules used by Squid. I have commented each block so you can easily understand the purpose of each one.

NOTICE: the term 'BUMP' refers the steps used during the process where Squid decrypt, storage in the cache and re-encrypt, the Secured connections (TLS/SSL) between the client (any device connected zt home to the proxy) and the server (any web page you want to browse).

```
# Protocols
acl FTP proto FTP
acl HTTP proto HTTP
acl HTTPS proto HTTPS

# Methods
acl GET method GET
acl POST method POST
acl CONNECT method CONNECT
acl HEAD method HEAD
acl PURGE method PURGE

# Bump steps
acl BUMP_STEP1 at_step SslBump1 # Client
acl BUMP_STEP2 at_step SslBump2 # Server
acl BUMP_STEP3 at_step SslBump3

# Safe Ports
acl Safe_Ports port 9 # WoL
acl Safe_Ports port 53 # dns
acl Safe_Ports port 953 # dns
acl Safe_Ports port 80 # http
acl Safe_Ports port 139 # samba
acl Safe_Ports port 443 # https
acl Safe_Ports port 445 # samba
acl Safe_Ports port 631 # cups
acl Safe_Ports port 1344 # c-icap
acl Safe_Ports port 1883 # mosquitto
acl Safe_Ports port 3127 # squid
acl Safe_Ports port 3128 # squid
acl Safe_Ports port 3129 # squid
acl Safe_Ports port 3130 # ICP
acl Safe_Ports port 4827 # HTCP

# SSL Ports
acl SSL_Ports port 139 # samba
acl SSL_Ports port 443 # https
acl SSL_Ports port 445 # samba
acl SSL_Ports port 1344 # c-icap
acl SSL_Ports port 3127 # Squid
acl SSL_Ports port 3128 # Squid
acl SSL_Ports port 3129 # Squid

# Localnet
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
acl localnet src 127.0.0.1

# Server
acl HOME dst {{your-lan-name}}

# Use ssl::server_name / ssl::server_name_regex / dstdomain
acl POOL_UPDATES ssl::server_name_regex -i "/etc/squid/acl/pool.acl"

# Browsers
acl BROWSERS browser Mozilla
acl BROWSERS browser Edge
acl BROWSERS browser Safari
acl BROWSERS browser Gecko
acl BROWSERS browser Chrome
acl BROWSERS browser AppleWebKit

# Ajax Requests
acl XHR req_header HTTP_X_REQUESTED_WITH -i xmlhttprequest

# Windows Clients
acl WINDOWS req_header User-Agent -i Windows

# Tor 
acl TOR ssl::server_name "/etc/squid/acl/tor.acl"

# Bump Exclude
acl BUMP_EXCLUDE_DOMAINS ssl::server_name "/etc/squid/acl/bump/exclude-domains.acl"
acl BUMP_EXCLUDE_MEDIA urlpath_regex -i "/etc/squid/acl/bump/exclude-media.acl"
acl BUMP_EXCLUDE_ANDROID req_header User-Agent -i "/etc/squid/acl/bump/exclude-android.acl"
acl BUMP_SKIP_BUMPED req_header X-SSL-Bump -i skip
acl BUMP_FORCE_BUMPED req_header X-SSL-Bump -i force

# Cache Exclude
acl CACHE_EXCLUDE_DOMAINS urlpath_regex -i "/etc/squid/acl/cache/exclude-domains.acl"
acl CACHE_EXCLUDE_MEDIA urlpath_regex -i "/etc/squid/acl/bump/exclude-media.acl"

# Times
acl PEAK_PERIOD time 08:00-23:00
acl UNLOCKED_PERIOD time 08:00-18:00

# Intermediate Certificates
acl INTERMEDIATE_FETCH transaction_initiator certificate-fetching

# Connections Over TLS
acl TLS_CONN connections_encrypted

# Certificate errors
acl CERT_ERR ssl_error X509_V_ERR_CERT_REVOKED

```

# HTTP Access
http_access allow localhost
http_access allow manager localhost
http_access deny manager
http_access allow PURGE localhost
http_access deny PURGE
http_access deny !Safe_Ports
http_access deny CONNECT !SSL_Ports
http_access allow localnet
http_access deny CERT_ERR
http_access deny INTERMEDIATE_FETCH
http_access allow AUTHENTICATED
http_access deny all

# ICP Access
icp_access allow localhost
icp_access deny all

# HTCP Access
htcp_access allow localhost
htcp_access deny all
