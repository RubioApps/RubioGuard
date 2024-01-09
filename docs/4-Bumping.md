# The **'touchy'** block

I named this **the touchy block** because this is the part that could be seen by the remote servers as an abnormal proxy.

To better understand this block, you have to know that a proxy server is a machine that works between the client and the server.

For instance, if you want to connect from your PC to github.com via a proxy server, github.com will only see that the proxy connected, but not the client behind the proxy.

If the proxy has somehow intercepted the traffic, it will let a trace on it. If that trace it detected by the remote server and it does not accept it, the remote server could end the connection abruptly.

Typically, the Cloudfare protection might block the traffic coming from a misconfigured Proxy Server.

Therefore, if you want your proxy to act as a "man-in-the-middle' (to store the HTTPS requests and responses into a cache), you would need to proceed by tuning a process which named "Bumping".

NOTE:
I remind you that, as the clients and the Proxy Server are all inside your domestic Local Network, it might be no issue if you use a man-in-the-middle, becase everything "stays at home". In any case, even that might be illegal in some countries, depending on the Law.

## External Generator of certificatesEXTERNAL SSL_CRTD 

This is mandatory for the bumping. By using this program, Squid will generate a certificate on-the-fly and it will be used for the given connection.
Prior to use it, you have to build a database of certificates.

You can proceed as it follows:

```
sudo /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB 
chown -R proxy:proxy /var/lib/squid/ssl_db

```

Afterwards, we can use that new brand dabatase for the described purposes by adding in squid.conf

```
sslcrtd_program /usr/lib/squid/security_file_certgen -d -s /var/lib/squid/ssl_db -M 4MB options=ALL
sslcrtd_children 20 startup=5 idle=1
```


## Bumping

### Skip bump

Here I decided to NOT TO BUMP some domains. This is done based on the ACL defined in the files of the subfolder /etc/squid/acl.
As you see, I do not bump some android user agents, some sensitive domains, some media (like videos), etc.

Why? Because it will be blocked or because I do not need to. 

__REMIND__:

The purpose of the bumping is to decrypt the SSL traffic before caching it. Otherwise, it cannot be cached. 

For instance, if you connect to your bank, you do not need to cache or hide your identity behind a proxy.
Thefore, the domain of your bank shall be included into the list of excluded domains.


```
ssl_bump splice localhost
ssl_bump splice HOME
ssl_bump splice BUMP_EXCLUDE_ANDROID
ssl_bump splice BUMP_EXCLUDE_DOMAINS
ssl_bump splice BUMP_EXCLUDE_MEDIA
ssl_bump splice BUMP_SKIP_BUMPED
ssl_bump splice TOR
ssl_bump splice XHR
```

### Force Bump

For the rest of the websites or remote connections, I am interested on bumping the connections done with an internet browser.
Therefore, I peek the connection, I do the handshake with the remote server, and then I bump.

Finally, I splice again the rest of the connections.

```
ssl_bump peek BUMP_STEP1
ssl_bump stare BUMP_STEP2
ssl_bump bump BUMP_FORCE_BUMPED
ssl_bump bump BROWSERS
ssl_bump splice all
```

## Spoofing (optional)

Spoofing is the term used to describe the mechanisms of alter the HTTP headers sent to the remote server.
You can use it if you want the remote server to ignore from which webpage are you landing off (via or forwarded_for).

__NOTE__: 

>This violates the HTTP standard, and it could turn the browing into a very difficult task. 
>This spoofing is usually blocked by cloudflare.com

You can add the following lines to the squid.conf. 

```
via on
#forwarded_for delete
follow_x_forwarded_for allow localhost
follow_x_forwarded_for allow localnet
follow_x_forwarded_for deny all

#Spoofed headers
request_header_access X-Forwarded-For deny all
reply_header_access X_Forwarded_For deny all

```
I do recommend to NOT to delete the forwarders. Browsing on Internet with this kind of spoofing could be a nightmare.
