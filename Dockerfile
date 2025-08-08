FROM internetsystemsconsortium/bind9:9.18
WORKDIR /

RUN apk update
RUN apk add alpine-conf
RUN setup-apkrepos -c -1
RUN apk update
RUN apk add bind-tools
RUN apk add bash
RUN apk add nginx 
RUN apk add php81-fpm
RUN mkdir /template

COPY ./src/update.php /template/update.php
COPY ./src/nginx_default_site /etc/nginx/sites-available/default
COPY ./src/zone /template/
COPY ./src/root.hints /usr/share/dns/root.hints
COPY ./src/named.conf.local.zone_config /template/
COPY ./src/named.conf.local /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80

#ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT [ "/start.sh" ]
#CMD [""]

