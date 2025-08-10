FROM alpine:3.22.1
WORKDIR /

RUN apk update
RUN apk add alpine-conf
RUN setup-apkrepos -c -1
RUN apk update
RUN apk add openrc bind bind-tools bash nginx php84 php84-fpm
RUN mkdir /template

COPY ./src/nginx_default_site /etc/nginx/http.d/default.conf
COPY ./src/root.hints /usr/share/dns/root.hints
COPY ./src/template/ /template/
COPY ./src/named/ /etc/bind/
COPY ./src/start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80

ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT [ "/start.sh" ]
