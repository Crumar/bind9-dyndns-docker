#!/bin/bash



IFS='|' read -ra ADDR <<< "$DOMAIN"
for i in "${ADDR[@]}"; do
    cat /template/update.php | sed "s/<DOMAIN>/${i}/g" > /var/www/html/$i.php
    cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
    cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
done


chown -R root:bind /etc/bind
chown -R bind:bind /var/lib/bind
chown -R www-data:www-data /var/www
chown -R www-data:www-data /var/lib/nginx

/etc/init.d/php8.1-fpm start
/etc/init.d/named start
su -s /bin/bash -c "/usr/sbin/nginx -g 'daemon off;'" www-data