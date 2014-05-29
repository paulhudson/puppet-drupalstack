<?php

if (!isset($argv[1]))
{
    exit;
}
$command = $argv[1];

$pid = pcntl_fork();
if ($pid < 0) // error
    exit;
else if ($pid) // parent
    exit;
else // child
{
    // Write to config
    $conf_file = '/var/log/drupal-install';
    $msg = "running command: $command \n";

    $handle = fopen($conf_file, 'a');
    fwrite($handle, $msg);
    fclose($handle);

    $sid = posix_setsid(); // creates a daemon

    if ($sid < 0)
        exit;

    exec("{$command} >> /dev/null 2>&1 &");
}
