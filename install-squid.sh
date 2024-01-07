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