<?php 

$ip  = $_SERVER['REMOTE_ADDR'];
echo "$ip<br>";
// don't miss to use escapeshellarg(). Make it impossible to inject shell code
$mac = shell_exec('arp -a ' . escapeshellarg($ip));

// can be that the IP doesn't exist or the host isn't up (spoofed?)
// check if we found an address
if(empty($mac)) {
    die("No mac address for $ip not found");
}

// having it
echo "mac address for $ip: $mac";

?>