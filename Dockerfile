FROM internetsystemsconsortium/bind9:9.20
WORKDIR /
RUN setup-apkrepos -c -1
RUN apk update
RUN apk add bind-tools 
RUN apk add nginx 
RUN apk add php81-fpm
RUN mkdir /template
COPY ./src/update.php /template/update.php
COPY ./src/nginx_default_site /etc/nginx/sites-available/default
COPY ./src/zone /template/
COPY ./src/named.conf.local.zone_config /template/
COPY ./src/named.conf.local /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80

CMD ["/start.sh"]

