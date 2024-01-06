# Networking

The configure options parameter must contain the --enable-ssl-crtd and --with-openssl values.

Copy the SSL certificate+key in PEM format into the folder /etc/squid/ssl

- Put generate-host-certificates=on
- Enable a sslcrtd_program

For a reinforced security, generate the settings file for the Diffie-Hellman algorithm.
To do so, execute the command:

``` 
openssl dhparam -outform PEM -out /etc/squid/ssl/{{your_easyRSA_name}}-dh.pem 2048
```

There is 2 ways to make the traffic goes through the proxy:

- You force of the traffic to pass through the Proxy: 
You would need to setup the iptables and the routing tables at your server
As this is quite complicate, let's take the first option

or

- Any indiviual device is configured to use it: (recommended)
Setup your internet browser or your PC to use this proxy. You only have to setup the proxy to point to 

http://<your_ip_server>:3128

and redirect all the traffic to it.

```
http_port 3128 ssl-bump \
    generate-host-certificates=on \
    dynamic_cert_mem_cache_size=64MB \
	tls-cert=/etc/squid/ssl/{{your_easyRSA_name}}.crt \
	tls-key=/etc/squid/ssl/{{your_easyRSA_name}}.key \
	tls-dh=prime256v1:/etc/squid/ssl/{{your_easyRSA_name}}-dh.pem \
    tls-default-ca=on
```

## DNS

This option is used by the  Proxy to resolve the names.

```
dns_nameservers 1.1.1.1
dns_multicast_local on
dns_timeout 3 seconds
```
