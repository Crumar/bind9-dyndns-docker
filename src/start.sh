#!/bin/bash

IFS='|' read -ra ADDR <<< "$DOMAIN"
for i in "${ADDR[@]}"; do
    if [ ! -f /var/lib/bind/d.$i ]; then
        cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
        cat /template/update.php | sed "s/<DOMAIN>/${i}/g" > /var/www/html/$i.php
        cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
        echo "" >> /etc/bind/named.conf.local
    fi
done


chown -R root:bind /etc/bind
chown -R bind:bind /var/lib/bind

/etc/init.d/php8.1-fpm start
/etc/init.d/nginx start
su -s /bin/bash -c "/usr/sbin/named -g" bind