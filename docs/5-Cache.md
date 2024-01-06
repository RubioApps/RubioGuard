# Cache

In Squid, the fastest way to access to the cache is when it is stored in the memory.
When Squid is using the disk storage mode, it's slower than storing the objects in the memory, but you can store more if you are short of memory (12GB in my case).

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
#cache_dir aufs /var/cache/squid 2048 16 256
#minimum_object_size 0
maximum_object_size 512 KB
```

This can change depending on the machine where you run the Squid Proxy Server. 
The suggested values work fine for me.


## Pools

Some services running on the PC clients can use a big portion of the bandwidth at home. Therefore, some traffic related to Windows update, Antivirus updates, etc. can be put in a pool. 

If we se tthe size of that pool, we ensure that traffic will never go higher than the size of the pool.
This will allow the other connections to work properly.

Let's tune the pool for the following ACLs: 
- POOL_UPDATE: I put all the domains like windowsupdate
- PEAK_PERIOD: This is a rule that says in which period of the day I allow the pool to work. Usually, at night.

```
delay_pools 1
delay_class 1 1
delay_parameters 1 8000/8000
delay_access 1 allow POOL_UPDATES PEAK_PERIOD
delay_access 1 deny all
```

## Tuning the cache

This block manages the way the cache is stored and how it reacts to the request like "does this object already exists?"

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
