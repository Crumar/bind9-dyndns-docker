<?php
        header('Content-Type: text/plain');
        $subdomain = $_GET['subdomain'];
        $u = $_GET['source'];
        $address = $_GET['addr'];
        $d=gmdate("Y-m-d\TH:i:s\Z", time());

        $descriptorspec = array(
                0 => array('pipe', 'r'),
                1 => array('pipe', 'w')
        );
        $process = proc_open('nsupdate', $descriptorspec, $pipes, NULL, NULL);


        fwrite($pipes[0], "server 127.0.0.1\n");
        fwrite($pipes[0], "update delete $subdomain.d.<DOMAIN>. A\n");
        fwrite($pipes[0], "update delete $subdomain.d.<DOMAIN>. TXT\n");
        fwrite($pipes[0], "update add $subdomain.d.<DOMAIN>. 2 A $address\n");
        fwrite($pipes[0], "update add $subdomain.d.<DOMAIN>. 2 TXT \"Updated by $u $d\"\n\n");
        fclose($pipes[0]);
        print("\nReturn:\n");
        echo stream_get_contents($pipes[1]);
        print("\nDone.\n$address\n");
        proc_close($process);
?>