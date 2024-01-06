# The squid.conf file explained

I have splitted this explanation in multiple blocks to better understand the content:

1. Protection
 1. Access to the Squid Proxy
 2. Access to the Cache Manager
 3. Access Control Lists (ACL)
 4. Application of the ACL depending on the protocols HTTP / ICP / HTCP 
2. Networking
 1. Ports
 2. DNS
 3. TCP / SSL / TLS / ICP options
3. The **'touchy'** block
 1. Temporary Certificate Generation (SSL_CRTD)
 2. Spoofing HTTP headers
 3. Bumping
8. Cache   
 1. Memory Cache options
 2. Tuning
 3. Pools
 4. Refresh policy
9. Filtering
 1. Rewriting
 2. C-ICAP
10. Administrative Options
 1. User, Process, etc.
 2. DNS
 3. Icons
 4. Error Pages
 5. External programs
11. Peer Proxy Servers: Privoxy as a filtering server
 1. Cache Digest options
 2. Redirect to TOR
12. Logging and Troubleshooting


I have redacted one file per block. Please refers to the /docs


 
