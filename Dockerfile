FROM debian:bookworm-slim
WORKDIR /
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt-get install -y dnsutils nginx php8.2-fpm bind9 net-tools
RUN mkdir /template

COPY ./src/update.php /template/update.php
COPY ./src/nginx_default_site /etc/nginx/http.d/default.conf
COPY ./src/zone /template/
COPY ./src/root.hints /usr/share/dns/root.hints
COPY ./src/named.conf.local.zone_config /template/
COPY ./src/named.conf.local /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80
EXPOSE 53


#ENTRYPOINT ["tail", "-f", "/dev/null"]
CMD ["/start.sh"]

