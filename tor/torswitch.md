# Create a TOR Auto Switch Service

This service runs on the background and forces the TOR connection to be refreshed every 15 minute
This can be done on Ubuntu 22.04 by creating a service managed by systemd:

__Create a file__: /etc/systemd/system/torswitch.service
__Paste the following content__:

```
[Unit]
Description=TOR IP auto switch
After=network.target nss-lookup.target

[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /etc/tor/autoswitch.py

[Install]
WantedBy=multi-user.target
```

__Create a file__: /etc/systemd/system/torswitch.timer
__Paste the following content__

```
[Unit]
Description=TOR IP Autoswitch every 15 minutes starting in 0

[Timer]
OnCalendar=*-*-* *:0/15
Persistent=true

[Install]
WantedBy=timers.target
```
__Enable the service__:

```
systemctl enable torswitch.service torswitch.timer
```

__Start the service__:

```
systemctl start torswitch.service torswitch.timer
```
