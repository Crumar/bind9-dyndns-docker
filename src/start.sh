#!/bin/bash

mkdir -p /var/www/html/

echo $DOMAIN > /start.out
OIFS=$IFS
IFS='|' 
domains=$DOMAIN


for i in $domains; do
    if [ ! -f /var/lib/bind/d.$i ]; then
        cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
        cat /template/update.php | sed "s/<DOMAIN>/${i}/g" > /var/www/html/$i.php
        cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
        echo "" >> /etc/bind/named.conf.local
    fi
done

IFS=$OIFS

chown -R bind:bind /etc/bind
chown -R bind:bind /var/lib/bind
chown -R bind:bind /var/log/named/
chown -R bind:bind /var/log/bind/
chown -R bind:bind /var/cache/bind
chown -R bind:bind /usr/share/dns
chown -R nginx:nginx /var/www/html

/etc/init.d/php8.1-fpm start
/etc/init.d/nginx start
su -s /bin/bash -c "/usr/sbin/named -g" bind