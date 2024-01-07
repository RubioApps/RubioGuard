# Peer Proxies

As I mentioned at the begining of this tutorial, one of the features I used from Squid Proxy Server is the ability to forward the traffic to a TOR server.
If you want to do so, you have to:

- Install Privoxy: filtering server that allows to redirect the HTTP packages to a socks5
- Install TOR and to configure it to redirect 

In other words, the TCP packages will be transfered in that way:

>Squid <-> Privoxy <-> TOR


I put an example of a TOR and a Privoxy config files in this repository.


## Cache digest (optional)

As we do not connect to any ther Proxy Cache (Privoxy does not store any cache but only filters), we do not need the Digest generation

```
digest_generation off
digest_bits_per_entry 5 
digest_rebuild_period 4 hours
digest_rewrite_period 4 hours
digest_swapout_chunk_size 4096 bytes 
digest_rebuild_chunk_percentage 10
```

## Set the Peers

Now, I tell to Squid to redirect the traffic to a parent proxy Privoxy that listens on the port 8118.
Privoxy will redirect it to the socks5 where TOR is listening.

Unfortunately, Squid Proxy does not allow to redirect to TOR socks5 yet. So, we need to use Privoxy as a mandatory step.

```
#Requires privoxy and tor configured on localhost and running
prefer_direct on
always_direct deny TOR BROWSERS
always_direct allow all

never_direct allow TOR BROWSERS
never_direct deny all

#Uses Privoxy for forwaring purposes for TOR
cache_peer 127.0.0.1 parent 8118 0 no-query no-digest no-netdb-exchange name=privoxy
cache_peer_access privoxy allow TOR BROWSERS 
cache_peer_access privoxy deny all
```

This is almost finished!
