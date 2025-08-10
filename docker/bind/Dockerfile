FROM alpine:3.22.1
WORKDIR /

RUN apk update
RUN apk add alpine-conf
RUN setup-apkrepos -c -1
RUN apk update
RUN apk add openrc bind bind-tools bash
RUN mkdir /template

#COPY ./src/root.hints /usr/share/dns/root.hints
COPY ./template/ /template/
COPY ./etc/ /etc/bind/
COPY ./start.sh /start.sh
RUN chmod +x /start.sh


EXPOSE 80

ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT [ "/start.sh" ]
