# Peer Proxies

As I mentioned at the begining of this tutorial, one of the features I used from Squid Proxy Server is the ability to forward the traffic to a TOR server.
If you want to do to , you have to:

- Install Privoxy: filtering server that allows to redirect the HTTP packages to socks5
- Install TOR and to configure it to redirect 

In other words, the TCP packages will be transfered in that way:

>Squid <-> Privoxy <-> TOR


I have put an example of TOR and Privoxy config files in the root of this repository.



## Cache digest

As we do not connect to any ther Proxy Cache (Privoxy does not store any cache but only filters), we do not need the Digest generation

```
digest_generation off
digest_bits_per_entry 5 
digest_rebuild_period 4 hours
digest_rewrite_period 4 hours
digest_swapout_chunk_size 4096 bytes 
digest_rebuild_chunk_percentage 10
```

# Set the peers

Now we tell to Squid to send the traffic to the parent proxy Privoxy, who will redirect it to the socks5 where TOR is listening.
Unfortunately, this is needed because Squid does not allow to redirect to socks5 yet.

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
