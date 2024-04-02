#!/bin/bash

sed -i "s/<DOMAIN>/${DOMAIN}/" /var/www/html/update.php

cp /template/zone /var/lib/bind/d.$DOMAIN
cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${DOMAIN}/" >> /etc/bind/named.conf.local
sed -i "s/<DOMAIN>/${DOMAIN}/g" /var/lib/bind/d.$DOMAIN

/etc/init.d/named start
/etc/init.d/php8.1-fpm start
/usr/sbin/nginx -g 'daemon off;'