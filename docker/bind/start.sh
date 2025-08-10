#!/bin/bash
dirs=("/etc/bind" "/var/bind" "/var/lib/bind" "/var/log/named" "/var/log/bind" "/usr/share/dns" "/var/cache/bind" "/var/cache/named")

cp /etc/bind/named.conf.authoritative /etc/bind/named.conf
echo "include \"/etc/bind/named.conf.local\";" >> /etc/bind/named.conf

for d in ${dirs[@]}; do 
    mkdir -p $d
done

OIFS=$IFS
IFS='|' 
domains=$DOMAIN

for i in $domains; do
    echo "Setting up zone for $i"
    if [ ! -f /var/lib/bind/d.$i ]; then
        cat /template/zone | sed "s/<DOMAIN>/${i}/g" > /var/lib/bind/d.$i
        cat /template/named.conf.local.zone_config | sed "s/<DOMAIN>/${i}/" >> /etc/bind/named.conf.local
        echo "" >> /etc/bind/named.conf.local
    fi
done

IFS=$OIFS

for d in ${dirs[@]}; do 
    chown -R named:named $d
done

shopt -s nullglob dotglob     # To include hidden files
files=(/some/dir/*)

if [ ${#files[@]} -gt 0 ]; then 
    su -s /bin/bash -c "/usr/sbin/named -g -u named" named
else
    echo "No domains found in $DOMAIN"
fi
