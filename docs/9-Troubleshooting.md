# Troubleshooting

When connecting to a website through a Proxy Server, it would be interesting to know what is stored in the cache, what is seen for the first time, etc.
If you want to check the logs, you can configure the format of the logfiles as it follows:


## Logfile format

```
logformat squid-nas %ts.%03tu %6tr %>a %Ss/%03>Hs %<st %rm %ru %[un %Sh/%<a %mt "%{User-Agent}>h" %Ss:%Sh
logformat squid-icap  %ts.%03tu %6icap::tr %>A %icap::to/%03icap::Hs %icap::<st %icap::rm %icap::ru %un -/%icap::<A -

logfile_rotate 5
access_log daemon:/var/log/squid/access.log logformat=squid-nas
cache_store_log daemon:/var/log/squid/store.log
buffered_logs on
strip_query_terms on
```


## Logfile content

Here I decided to make "None". You can uncomment the section you want to see in the logs.

```
cache_log /var/log/squid/cache.log
coredump_dir /var/cache/squid
debug_options ALL,0	# None
#debug_options ALL,1	# Default
#debug_options ALL,2	# Detailed
#debug_options 11,5		# HTTP
#debug_options 28,3		# Access Control
#debug_options 73,3		# HTTP Request
#debug_options 83,3		# SSL Bump
```

That's all about the squid.conf
