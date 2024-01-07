# Networking

To setup this block, you had compiled the Squid Proxy Server with the options *--enable-ssl-crtd* and *--with-openssl*.
Otherwise, it did not work.

## Create a Self-signed Certificate

First, you have to generate a Self-Signed certificate with OpenSSL. This is done with the following steps:


__STEP 1__: Create the server private key
```
openssl genrsa -out squid.key 2048
```

__STEP 2__: Create the certificate signing request (CSR)
```
openssl req -new -key squid.key -out squid.csr
```

__STEP 3__: Sign the certificate using the private key and CSR
```
openssl x509 -req -days 3650 -in squid.csr -signkey squid.key -out squid.crt
```

Then, move the SSL certificate (squid.crt) and the private key (squid.key) into the folder /etc/squid/ssl

For a reinforced security, generate the settings file for the Diffie-Hellman algorithm.
To do so, execute the command:

``` 
openssl dhparam -outform PEM -out /etc/squid/ssl/squid-dh.pem 2048
```

There is 2 ways to make the traffic goes through the proxy:

__OPTION 1__: You force of the traffic to pass through the Proxy: 

You would need to setup the iptables and the routing tables at your server.
As this is quite complicate, let's take the next option

or

__OPTION 2__: Any indiviual device is configured to use the proxy (recommended).

Setup your internet browser or your PC to use this proxy. You only have to setup the proxy to point to 

>http://<your_ip_server>:3128

and redirect all the traffic to it.

Here below we define the configuration of the port where the Squid Proxy will listen the connections:

```
http_port 3128 ssl-bump \
    generate-host-certificates=on \
    dynamic_cert_mem_cache_size=64MB \
	tls-cert=/etc/squid/ssl/squid.crt \
	tls-key=/etc/squid/ssl/squid.key \
	tls-dh=prime256v1:/etc/squid/ssl/squid-dh.pem \
    tls-default-ca=on
```


## DNS

This option is used by the Proxy to resolve the namesof the remote servers.

```
dns_nameservers 1.1.1.1
dns_multicast_local on
dns_timeout 3 seconds
```

## TCP / SSL / TLS / ICP options

Here we configure the options related to the secured layer

### TCP OPTIONS (optional)

These options are not mandatory. I use them because I do prefer to have a mark on the TCP packet saying that it has passed through TOR.
Therefore, if I need it in the future, and can use it for further filtering at the routing / iptables tables of my router.

```
tcp_outgoing_mark 0x0 !TOR all
tcp_outgoing_mark 0x1 TOR
```

### ICP OPTIONS (optional)

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

These options define the way the SSL is done. 

```
sslproxy_session_ttl 300
sslproxy_session_cache_size 4 MB
sslproxy_cert_error allow all
```

There is an optional check you can include into this block.
By adding a "deny CERT_ERR"when the Squid Proxy server connects to a remote server that has any issue with its certificate, it will be rejected.

So, the lines becomes as it follows:

```
sslproxy_session_ttl 300
sslproxy_session_cache_size 4 MB
sslproxy_cert_error deny CERT_ERR
sslproxy_cert_error allow all
```

I do not use it because I trust my browser to do the job.
As we use Squid Proxy server through an Internet Browser (Brave, Firefox or DuckDuck go), I'll let the browser to refuse the invalid certificates.

### TLS OPTIONS : Custom config SSL-MITM mode

```
tls_outgoing_options capath=/etc/ssl/certs
tls_outgoing_options cipher=ALL:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH
tls_outgoing_options options=NO_SSLv3,NO_TLSv1,NO_TLSv1_1
```


