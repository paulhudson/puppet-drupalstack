<?php

$temp_command = isset($argv[1]) ? isset($argv[1]) : 'nada';
// Write to config
$conf_file = '/var/log/drupal-install';
$msg = "running command: $temp_command \n";

$handle = fopen($conf_file, 'a');
fwrite($handle, $msg);
fclose($handle);

if (!isset($argv[1]))
{

    // Write to config
    $conf_file = '/var/log/drupal-install';
    $msg = "fail 1 \n";

    $handle = fopen($conf_file, 'a');
    fwrite($handle, $msg);
    fclose($handle);

    exit;
}
$command = $argv[1];

$pid = pcntl_fork();
if ($pid < 0) // error

    // Write to config
    $conf_file = '/var/log/drupal-install';
    $msg = "fail 2 \n";

    $handle = fopen($conf_file, 'a');
    fwrite($handle, $msg);
    fclose($handle);

    exit;
else if ($pid) // parent

    // Write to config
    $conf_file = '/var/log/drupal-install';
    $msg = "fail 3 \n";

    $handle = fopen($conf_file, 'a');
    fwrite($handle, $msg);
    fclose($handle);

    exit;
else // child
{

    // Write to config
    $conf_file = '/var/log/drupal-install';
    $msg = "pass 1 \n";

    $handle = fopen($conf_file, 'a');
    fwrite($handle, $msg);
    fclose($handle);

    $sid = posix_setsid(); // creates a daemon

    if ($sid < 0)

        // Write to config
        $conf_file = '/var/log/drupal-install';
        $msg = "fail 4 \n";

        $handle = fopen($conf_file, 'a');
        fwrite($handle, $msg);
        fclose($handle);

        exit;

    exec("{$command} >> /dev/null 2>&1 &");
}
