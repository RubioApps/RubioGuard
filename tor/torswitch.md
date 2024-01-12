# Create a TOR Auto Switch Service

This service runs on the background and forces the TOR connection to be refreshed every 15 minute
This can be done on Ubuntu 22.04 by creating a service managed by systemd:

Before doing this, you have already created the file /etc/tor/autoswitch.py
You'll find this python script within this folder.

Please remind that all the files have to be owned by root. Then, please run the shell commands in sudo -u root mode.

. Create the file: 

```
nano /etc/systemd/system/torswitch.service
```

. Paste the following content, and save:

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

. Create a file: 

```
nano /etc/systemd/system/torswitch.timer
```

. Paste the following content, and save:

```
[Unit]
Description=TOR IP Autoswitch every 15 minutes starting in 0

[Timer]
OnCalendar=*-*-* *:0/15
Persistent=true

[Install]
WantedBy=timers.target
```
. Enable the service:

```
systemctl enable torswitch.service torswitch.timer
```

. Start the service:

```
systemctl start torswitch.service torswitch.timer
```

Now, this service will connect to the TOR service, using the autoswitch.py script, which contains the secret plain password.
In the other hand, the TOR service contains the hashed password of the used one, which allows the connection.



