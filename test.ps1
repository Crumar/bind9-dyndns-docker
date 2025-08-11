Invoke-WebRequest "http://127.0.0.1:8880/example.de.php?subdomain=t&addr=8.8.8.8&source=test" | out-null

Invoke-WebRequest "http://127.0.0.1:8880/example.de.php?subdomain=t&addr=2620:fe::fe&source=test" | out-null

Start-Sleep 1

# Resolve-DnsName -Name t.d.example.de -Server 127.0.0.1
docker exec test sh -c "/usr/bin/dig t.d.example.de A +short @127.0.0.1"
docker exec test sh -c "/usr/bin/dig t.d.example.de AAAA +short @127.0.0.1"