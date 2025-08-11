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

        $isValid4 = filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $isValid6 = filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);

        if($isValid4 == $address){
                $recordType="A";
        } elseif ($isValid6 == $address) {
                $recordType="AAAA";
        } else {
                http_response_code(400); exit;
        }

        fwrite($pipes[0], "server 127.0.0.1\n");
        fwrite($pipes[0], "update delete $subdomain.d.<DOMAIN>. $recordType\n");
        fwrite($pipes[0], "update delete $subdomain.d.<DOMAIN>. TXT\n");
        fwrite($pipes[0], "update add $subdomain.d.<DOMAIN>. 2 $recordType $address\n");
        fwrite($pipes[0], "update add $subdomain.d.<DOMAIN>. 2 TXT \"Updated by $u $d\"\n\n");
        fclose($pipes[0]);
        print("\nReturn:\n");
        echo stream_get_contents($pipes[1]);
        print("\nDone.\n$address\n");
        proc_close($process);
?>