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

> http://<your_ip_server>:3128

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

## TCP / SSL / TLS / ICP options

Here we configure the options related to the secured layer

### TCP OPTIONS 

These options are not mandatory. I use them because I do prefer to have a mark on the TCP packet saying that it has passed through TOR.
Therefore, if I need it in the future, and can use it for further filtering at the routing / iptables tables of my router.

```
tcp_outgoing_mark 0x0 !TOR all
tcp_outgoing_mark 0x1 TOR
```

### ICP OPTIONS

These options are used to define how the Squid Proxy server connects to another proxies (siblings or parent).
The ICP protocol is the one used for that purpose. As I do not want to work with other proxies, I have disabled the ICP port.

The same thought about the HTCP protocole (the most recent one but in essential it does the same than ICP)

```
log_icp_queries off
#Uncomment to use the standard ICP (cache protocol) with peers. Default port is 3130. Zero (0) disables it
icp_port 0
#Uncomment to use HTCP as a secured alternative to ICP. Default port is 4827. Zero (0) disables it
htcp_port 0
```

### SSL OPTIONS

These options define the way the SSL is done. There is an optional check of the remote certificate.
If the Proxy server tries to connect to a server having an issue with its certificate, it will be rejected by the proxy.

```
sslproxy_session_ttl 300
sslproxy_session_cache_size 4 MB
#sslproxy_cert_error deny CERT_ERR
sslproxy_cert_error allow all
```

As we use Squid Proxy server through an Internet Browser (Brave, Firefox or DuckDuck go), I let the browser do the job to refuse the invalid certificate.
So, I commented the following line 

> sslproxy_cert_error deny CERT_ERR

Then Squid will not avoid the connection, but the browser does.
As this option is too much restrictive, I do prefer to comment it out.


### TLS OPTIONS : Custom config SSL-MITM mode

```
tls_outgoing_options capath=/etc/ssl/certs
tls_outgoing_options cipher=ALL:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH
tls_outgoing_options options=NO_SSLv3,NO_TLSv1,NO_TLSv1_1
```


