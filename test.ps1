Invoke-WebRequest "http://127.0.0.1:8080/example.de.php?subdomain=t&addr=8.8.8.8&source=test"

Start-Sleep 1

nslookup t.d.example.de 127.0.0.1