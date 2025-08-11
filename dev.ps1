docker stop test
docker rm test
docker build -t bind9-dyndns-docker:dev_local .
docker run --name test `
    -p 53:53/udp `
    -p 53:53/tcp `
    -p 8880:80  `
    -e DOMAIN="example.de|example.com" `
    -d bind9-dyndns-docker:dev_local


