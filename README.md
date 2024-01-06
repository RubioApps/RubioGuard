# RubioGuard
Advanced Squid Proxy Cache with a redirect of the traffic to TOR

## Purpose

This is a tutorial to explain how to build a complex configuration for a Squid Proxy Server that includes an optional redirect of the traffic to Privoxy and TOR
This configuration CAN ONLY be used for personnal purposes in a domestic network, never a public one.

###**IMPORTANT NOTICE:**
.The use of a Man-in-the-middle might be illegal in some countries
.I decline any responsibility about the use of the following configuration and about any vulnerability devired from the third party software suggested in this tutorial

## Requirements

This is the list of needed software to build up the complete setup:

- Ubuntu Server 22.04 LTS Linux Operating System
- Squid Proxy Cache 5.7 or higher. More info at [Squid PRoxy](http://www.squid-cache.org/)
- Privoxy filtering content Server. More info at [Privoxy](https://www.privoxy.org/)
- TOR. More info at [TOR](https://packages.ubuntu.com/jammy/tor)
- C-ICAP Server. More info at [C-ICAP](https://c-icap.sourceforge.net/)
- EasyRSA. More info at [OpenVPN](https://github.com/OpenVPN/easy-rsa)

If you decide to disable any option across the following tutorial, you could not use the related service or server, and its installation would be not mandatory.

## Installation

To run the suggested configuration of the Squid proxy, you would need to compile it from the source.
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

Now create a bash script (for install named install-squid.sh) 

```
nano install-squid.sh
```

And paste the following content:

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

In addition to the Squid Proxy Server code, you would need to install the additional package for the Languages/
```
apt install squid-lang
```

## Structure

You have to create the following subfolders at /etc/squid
- ssl
- acl

**The folder 'ssl'** will contain the Self-signed Certificates, needed to run Squid with the capability to decrypt, cache and re-encrypt the traffic (man-in-the-middle)

To know further about how to create Self-Signed certificates with EasyRSA, please [visit the ArchiLinux page](https://wiki.archlinux.org/title/Easy-RSA)

At the end you will need 2 files:

- A certificate (.crt)
- A private key (.key)

**The folder 'acl'** will contain the rules that will allow to redirect the traffic depending on the domain you want to connect to
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

Now, you can copy and paste the content of the squid.conf at /etc/squid/

Please refer to more info into the /docs folder







