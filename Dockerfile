FROM debian:bookworm-slim
WORKDIR /
# One layer: a cached `apt-get update` in its own layer would make later
# rebuilds install stale packages. `upgrade` pulls security fixes into the
# base image's packages too (e.g. php8.2 >= 8.2.35-1~deb12u1 for
# CVE-2026-109618 / CVE-2026-109619).
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y dnsutils nginx php8.2-fpm bind9 net-tools \
    && rm -rf /var/lib/apt/lists/*
COPY ./src/php-hardening.ini /etc/php/8.2/fpm/conf.d/99-hardening.ini
RUN mkdir /template
COPY ./src/update.php /template/update.php
COPY ./src/nginx_default_site /etc/nginx/sites-available/default
COPY ./src/zone /template/
COPY ./src/named.conf.local.zone_config /template/
COPY ./src/named.conf.local /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80
EXPOSE 53

#ENTRYPOINT ["tail", "-f", "/dev/null"]
CMD ["/start.sh"]

