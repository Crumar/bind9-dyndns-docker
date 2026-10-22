<?php
        header('Content-Type: text/plain');

        // Every value below ends up in nsupdate's stdin, one command per line.
        // An unchecked newline (%0A) would let a caller append arbitrary
        // nsupdate commands, so each parameter is validated or sanitised.
        $subdomain = isset($_GET['subdomain']) ? $_GET['subdomain'] : '';
        $u = isset($_GET['source']) ? $_GET['source'] : '';
        $address = isset($_GET['addr']) ? $_GET['addr'] : '';
        $d=gmdate("Y-m-d\TH:i:s\Z", time());

        // One DNS label: letters, digits and inner hyphens, 1-63 characters.
        if (!is_string($subdomain) || !preg_match('/^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$/i', $subdomain)) {
                http_response_code(400); exit;
        }

        // Free text for the TXT record: keep printable ASCII only and drop
        // the characters that would end or escape the quoted TXT string.
        if (!is_string($u)) {
                http_response_code(400); exit;
        }
        $u = substr(preg_replace('/[^\x20-\x7E]|["\\\\;]/', '', $u), 0, 64);

        if (!is_string($address)) {
                http_response_code(400); exit;
        }
        $isValid4 = filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $isValid6 = filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6 | FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);

        if($isValid4 === $address){
                $recordType="A";
        } elseif ($isValid6 === $address) {
                $recordType="AAAA";
        } else {
                http_response_code(400); exit;
        }

        $descriptorspec = array(
                0 => array('pipe', 'r'),
                1 => array('pipe', 'w')
        );
        $process = proc_open('nsupdate', $descriptorspec, $pipes, NULL, NULL);

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
