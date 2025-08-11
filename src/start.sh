#!/bin/bash

nameddirs=("/etc/bind" "/var/bind" "/var/lib/bind" "/var/log/named" "/var/log/bind" "/usr/share/dns" "/var/cache/bind" "/var/cache/named")
nginxdirs=("/var/www/html" "/etc/nginx")

for d in ${nameddirs[@]}; do 
    mkdir -p $d
done

for d in ${nginxdirs[@]}; do 
    mkdir -p $d
done

IFS='|' read -ra ADDR <<< "$DOMAIN"
for i in "${ADDR[@]}"; do
    if [ ! -f /var/lib/bind/d.$i ]; then
        cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
        cat /template/update.php | sed "s/<DOMAIN>/${i}/g" > /var/www/html/$i.php
        cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
        echo "" >> /etc/bind/named.conf.local
    fi
done

for d in ${nameddirs[@]}; do 
    chown -R bind:bind $d
done

for d in ${nginxdirs[@]}; do 
    chown -R www-data:www-data $d
done

/etc/init.d/php8.2-fpm start
/etc/init.d/nginx start

shopt -s nullglob dotglob     # To include hidden files
files=(/var/lib/bind/*)


if [ ${#files[@]} -gt 0 ]; then 
    su -s /bin/bash -c "/usr/sbin/named -g" bind
else
    echo "No domains found in $DOMAIN"
fi