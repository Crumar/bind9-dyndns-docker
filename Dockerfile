FROM internetsystemsconsortium/bind9:9.18
WORKDIR /
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install -y dnsutils nginx 
RUN apt-get install -y php8.1-fpm
RUN mkdir /template
COPY ./src/update.php /var/www/html/
COPY ./src/nginx_default_site /etc/nginx/sites-available/default
COPY ./src/zone /template/
COPY ./src/named.conf.local.zone_config /template/
COPY ./src/named.conf.local /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80

CMD ["/start.sh"]

