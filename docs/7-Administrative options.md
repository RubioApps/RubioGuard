# Administrative options

This is the simpliest block of this tutorial. 
Here we define the settings that ensure that Squid Proxy Server runs correctly with your Operating System.

Here, I defined the locaiton of the PID, the username  and the name of the host that will be visible by the remote servers.

```
pid_filename /run/squid.pid
cache_effective_user proxy
cache_effective_group proxy
httpd_suppress_version_string on
visible_hostname squid-cache.org
```

## Icon options

In case of error, Squid Proxy will redirect your browser to a local webpage that uses some icons. I set the path:

```
global_internal_static on
icon_directory /usr/share/squid/icons
short_icon_urls off
```

## Error pages

Same logic for the error pages. I have customized mines but you can use the style (errorpage.css) of your choice and the language.
This comes with the package squid-lang, previously installed (see [README.md](https://github.com/RubioApps/RubioGuard/blob/main/README.md))

```
err_page_stylesheet /etc/squid/errorpage.css
error_directory /usr/share/squid/errors/fr
error_default_language fr
```

## Timeouts

We set some timeouts, so our Squid server will work under controlled conditions and it will reboot fast when needed.
This is mandatory.

```
forward_timeout 10 seconds
connect_timeout 10 seconds
shutdown_lifetime 1 second
```

# Use of external programs (optional)

As Squid allows to use its own program to ping a remote server or remote a file, we can setup the squid.conf to do so.
If this has NO BENEFIT for you in terms of performance. So, do not do it.

If you want to use its own pinger, you'll have to set the capability of the pinger.
This is a normal protection of Ubuntu and other systems to avoid any strange program to connect to internet without permission.

If you want to use it, type the following shell command:

```
setcap cap_net_raw=ep /usr/lib/squid/pinger
```

Then you can use the pinger by adding the following lines to the squid.conf file:

```
pinger_enable on
pinger_program /usr/lib/squid/pinger
unlinkd_program /usr/lib/squid/unlinkd
diskd_program /usr/lib/squid/diskd
```

