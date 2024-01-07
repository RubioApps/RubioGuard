# Cache

Squid Proxy Server uses the memomry as the fastest way to access to the stored objects.
When Squid is using the disk storage mode, it is slower but you can store bigger objects.

Let's tune it! 

## Memory options

Obviously, if we are going to use the memory, we have to define the limits in terms of size.
Hereinfater the suggested configuration:

```
cache_mem 512 MB  
memory_cache_mode always
memory_replacement_policy heap LFUDA
memory_pools on
memory_pools_limit 256 MB
maximum_object_size_in_memory 1024 KB
netdb_filename stdio:/var/spool/squid/netdb.state
```

And this for the disk:

```
cache_replacement_policy heap LFUDA
cache_dir aufs /var/cache/squid 2048 16 256
minimum_object_size 0
maximum_object_size 512 KB
```

This can be modified depending on the machine where you run the Squid Proxy Server. 
The suggested values work fine for me.


## Pools

Some services like Windows Update, Metrics or the Antivirus running on the PC clients can use a big portion of the bandwidth at home. 
Therefore, it is interesting to drive that traffic through a pool with a restricted timeslot.

If we set the size of that pool, we ensure that the local traffic will never be impacted by the mentioned services.
Then, the other connections will work properly when needed.

This is practical if you have a lot of devices connected to Internet and your ISP does not provide a large bandwidth.

Let's tune the pool for the following ACLs: 

__POOL_UPDATE__: I put all the domains like windowsupdate.com

__PEAK_PERIOD__: This is a rule that says in which period of the day I allow the pool to work. Usually, at night.

Please check the Chapter [2-Protection](https://github.com/RubioApps/RubioGuard/blob/main/docs/2-Protection.md) to check both conditions in detail.

```
delay_pools 1
delay_class 1 1
delay_parameters 1 8000/8000
delay_access 1 allow POOL_UPDATES PEAK_PERIOD
delay_access 1 deny all
```

## Tuning the cache

This part manages the way the objects are stored in the cache, and how the Squid Proxy reacts to the requests like "Does this object already exists?"

It works for me with the follwing settings:

```
quick_abort_min 1024 KB
read_ahead_gap 512 KB
store_avg_object_size 512 MB
send_hit deny CACHE_EXCLUDE_MEDIA
store_miss deny CACHE_EXCLUDE_MEDIA
```

## Refresh

There is 2 ways to say to Squid when to refresh the stored objects (in the memory or the disk):

- Including an external file
- Setting the hard-code in the squid.conf

Here I decided to use the external file /etc/squid/refresh_patterns.conf

```
include /etc/squid/refresh_patterns.conf
```

but you can use an alternative short version instead:

```
refresh_pattern -i ^ftp:                                        1440  20% 10000
refresh_pattern -i ^gopher:                                     1440   0% 1000
refresh_pattern -i http://(image|pic)s?\..+\?                   30    50% 19999   override-expire ignore-no-cache ignore-no-store ignore-private
refresh_pattern -i \.(zip|rar|bz2|gz|pdf|ps|css|js|swf)$        30    30% 9999    override-expire ignore-no-cache ignore-no-store ignore-private
refresh_pattern -i \.(avi|divx|mpe?g|mp.|ra|rm|wma|wmv|swv)$    43200 90% 432000  override-expire ignore-no-cache ignore-no-store ignore-private
refresh_pattern -i \.(png|jpe?g|gif|tif+|ico)$                  9999  50% 300000  override-expire ignore-no-cache ignore-no-store ignore-private
refresh_pattern -i .(html|htm|css|js)$				 			1440	40%	 40320
refresh_pattern    .                                            0     40%  40320
```
