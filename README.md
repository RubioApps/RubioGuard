# RubioGuard
This is an advanced configuration of Squid Proxy Cache with a redirect of the traffic to TOR

## Purpose

This is a tutorial to explain how to build a complex configuration for a Squid Proxy Server that includes an optional redirect of the traffic to Privoxy and TOR
This configuration CAN ONLY be used for personnal purposes in a domestic network, never a public one.

### **IMPORTANT NOTICE:**

- The use of a Man-in-the-middle might be illegal in some countries
- I decline any responsibility about the use of the following configuration and about any vulnerability provoked by a third party software suggested in this tutorial.

Once the setup is complete, you can use the Squid Proxy by:

- Adding a Self-Signed Certificate to your internet browser (chrome, Firefox, Brave, etc..)
- Setting your browser or PC to use **http://<your_ip_server>:3128** as the unique proxy address for all protocols.

## Requirements

- Ubuntu Server 22.04 LTS Linux Operating System
- Squid Proxy Cache 5.7 or higher. More info at [Squid PRoxy](http://www.squid-cache.org/)
- Privoxy filtering content Server. More info at [Privoxy](https://www.privoxy.org/)
- TOR. More info at [TOR](https://packages.ubuntu.com/jammy/tor)
- C-ICAP Server. More info at [C-ICAP](https://c-icap.sourceforge.net/) 


You can decide to disable an optional component across the following tutorial. 


## Installation

To run the provided configuration of the Squid Proxy Server (squid.conf), **you have to compile it from the source**.

You can get the source from [here](http://www.squid-cache.org/Versions/v5/squid-5.7.tar.gz)

You'll need **cmake** to compile the sources. Please do not forget to install it

You can read more information from Squid Proxy Cache by visiting the official repository [Squid v5](http://www.squid-cache.org/Versions/v5/)
For the suggested Stable Release v5.7 please refer to the [Release notes](http://www.squid-cache.org/Versions/v5/squid-5.7-RELEASENOTES.html)

You can run the following commands to download and unzip it:
```
apt install cmake -y
cd ~
wget http://www.squid-cache.org/Versions/v5/squid-5.7.tar.gz
tar -xvf squid-5.7.tar.gz
cd squid-5.7
```

Now create a bash script (for instance named *install-squid.sh*) 

```
nano install-squid.sh
```

Copy and paste the following content:

```
#!/bin/bash
 
./configure --prefix=/usr \
        --includedir=/usr/include \
        --datadir=/usr/share/squid \
        --bindir=/usr/bin \
        --sbindir=/usr/sbin \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --bindir=/usr/sbin \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib/squid \
        --localstatedir=/var \
        --sysconfdir=/etc/squid \
        --enable-ssl-crtd \
        --enable-inline \
        --disable-arch-native \
        --enable-async-io=8 \
        --enable-storeio=ufs,aufs,diskd,rock \
        --enable-removal-policies=lru,heap \
        --enable-delay-pools \
        --enable-cache-digests \
        --enable-icap-client \
        --enable-follow-x-forwarded-for \
        --enable-auth-basic=DB,fake,getpwnam,SMB \
        --enable-auth-digest=file \
        --enable-auth-negotiate=wrapper \
        --enable-auth-ntlm=fake \
        --enable-basic-auth-helpers=NCSA \
        --enable-external-acl-helpers=file_userip,kerberos_ldap_group,LDAP_group,session,SQL_session,time_quota,unix_group,wbinfo_group \
        --enable-url-rewrite-helpers=fake \
        --enable-eui \
        --enable-esi \
        --enable-icmp \
        --enable-wccp \
        --enable-zph-qos \
        --enable-ecap \
        --enable-translation \
        --enable-http-violations \
        --enable-linux-netfilter \
        --enable-arp-acl \
        --enable-static=yes \
        --enable-default-err-language=fr-fr \
        --with-openssl \
        --with-cap \
        --with-xml2 \
        --with-swapdir=/var/spool/squid \
        --with-logdir=/var/log/squid \
        --with-pidfile=/run/squid/squid.pid \
        --with-filedescriptors=65536 \
        --with-filedescriptors=65536 \
        --with-large-files \
        --with-default-user=proxy 

make 
make install  
```

Save it and run the script:

```
sudo bash ./install-squid.sh
```

This operation will take several minutes, depending on your machine.

Once Squid Proxy Cache is installed, you will found the working directory **/etc/squid**

In addition to the Squid Proxy Server code, you would need to install the additional package for the Languages:

```
apt install squid-lang
```

## Structure

You have to create the following subfolders at /etc/squid
- ssl
- acl

**The folder 'ssl'** will contain the Self-signed Certificates, mandatory to run Squid with the capability to decrypt, cache and re-encrypt the traffic (man-in-the-middle).

At the end you will need 2 files:

- A certificate (.crt)
- A private key (.key)

**The folder 'acl'** will contain the rules that allow to redirect the traffic depending on the domain you want to connect to.

In this repository, I provide the following rules:

- bump: (sub-folder)
  - exclude-android.acl : list of domains to NOT TO BUMP when browsing with a mobile device (applications like Snapchat or Messenger)
  - exclude-domains.acl : list of domains to NOT TO BUMP when browing with any device (banks or governments for instance)
  - exclude-media.acl : list of extensions to NOT TO BUMP (not cacheable content)
  - exclude-mime.acl : list of MIME types to NOT TO BUMP
  - force-mac.acl : this of MAC addresses of the device you want to force the bump (all the traffic with those devices will be bumped)
- cache (sub-folder)
  - exclude-domains.acl : list of domains to NOT TO CACHE when browing with any device (banks or governments for instance)
  - exclude-media.acl : list of extensions to NOT TO CACHE(not cacheable content)
  - exclude-mime.acl : list of MIME types to NOT TO CACHE
- pool.acl : list of domains that could flood your network but with low priority (windowsupdate or metrics)
- tor.acl : list of domains that you want to drive through TOR (not bumped and not cached, but 'torified')

Now, you can copy and paste the content of the [squid.conf](https://github.com/RubioApps/RubioGuard/blob/main/squid/squid.conf) at /etc/squid/

Please refer to more info into the [/docs](https://github.com/RubioApps/RubioGuard/tree/main/docs) folder.

## Legal

This repository simply contains the needed configuration for Squid, Privoxy and Tor. 
The use of it,user-submitted links to publicly available video stream URLs, which to the best of our knowledge have been intentionally made publicly by the copyright holders. If any links in these playlists infringe on your rights as a copyright holder, they may be removed by sending a [pull request](https://github.com/RubioApps/RubioGuard/pulls) or opening an [issue](https://github.com//RubioApps/RubioGuard/issues/new?assignees=freearhey&labels=removal+request&template=--removal-request.yml&title=Remove%3A+). 

However, note that we have **no control** over the destination of the link, and just removing the link from the playlist will not remove its contents from the web. Note that linking does not directly infringe copyright because no copy is made on the site providing the link, and thus this is **not** a valid reason to send a DMCA notice to GitHub. To remove this content from the web, you should contact the web host that's actually hosting the content (**not** GitHub, nor the maintainers of this repository).

## License

GNU GENERAL PUBLIC LICENSE

Version 3, 29 June 2007

Copyright (C) 2007 Free Software Foundation, Inc.







