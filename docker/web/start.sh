#!/bin/bash
nameddirs=("/etc/bind" "/var/bind" "/var/lib/bind" "/var/log/named" "/var/log/bind" "/usr/share/dns" "/var/cache/bind" "/var/cache/named")
nginxdirs=("/var/www/html" "/etc/nginx")

cp /etc/bind/named.conf.authoritative /etc/bind/named.conf
echo "include \"/etc/bind/named.conf.local\";" >> /etc/bind/named.conf

for d in ${nameddirs[@]}; do 
    mkdir -p $d
done
for d in ${nginxdirs[@]}; do 
    mkdir -p $d
done

OIFS=$IFS
IFS='|' 
domains=$DOMAIN

for i in $domains; do
    if [ ! -f /var/lib/bind/d.$i ]; then
        cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
        cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
        echo "" >> /etc/bind/named.conf.local
    fi
done

for i in $domains; do
    if [ ! -f /var/www/html/$i.php ]; then
        cat /template/update.php | sed "s/<DOMAIN>/${i}/g" > /var/www/html/$i.php
    fi
done

IFS=$OIFS

for d in ${nameddirs[@]}; do 
    chown -R named:named $d
done
for d in ${nginxdirs[@]}; do 
    chown -R nginx:nginx $d
done

# rc-service php-fpm84 start
# rc-service nginx start

su -s /bin/bash -c "/usr/sbin/named -g -u named" named