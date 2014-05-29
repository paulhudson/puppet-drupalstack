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

    $sid = posix_setsid(); // creates a daemon

    if ($sid < 0)
        exit;

    exec("{$command} >> /dev/null 2>&1 &");
}
