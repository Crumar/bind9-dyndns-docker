# bind9-dyndns-docker
Docker container that provides a bind9 server together with a dynamic dns zone.
A local web server (nginx) is added, that provides `update.php` with parameters to update the dynamic dns.

Example usage (not production ready):

    docker run --name bind9-dyndns -d bind9-dyndns-docker:latest \
        -p 53:53/udp \
        -p 53:53/tcp \
        -p 8080:80  \
        -e DOMAIN="example.de|example.com"

This creates two zones `d.example.com` and `d.example.de`, whose subdomains can be set using the `<DOMAIN>.php` like this:

    curl -X GET http://localhost:8080/example.com.php?subdomain=abc&addr=123.123.123.123&source=curltest

This will delete & add the following entries 

    update add abc.d.example.com. 2 A 123.123.123.123
    update add abc.d.example.com. 2 TXT "Updated by curltest 2024-04-02T16:54:03Z"

# Production Usage

You should secure the update.php with authentication and HTTPs, e.g. using traefik.
