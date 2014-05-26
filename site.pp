$apache_user = $operatingsystem ? {
  centos                => 'apache',
  redhat                => 'apache',
  /(?i)(ubuntu|debian)/ => 'www-data',
  default               => 'apache',
}

$apache = $operatingsystem ? {
  centos                => 'httpd',
  redhat                => 'httpd',
  /(?i)(ubuntu|debian)/ => 'apache2',
  default               => undef,
}

apache::vhost { 'drupal_site':
  port          => '80',
  docroot       => "/var/www/vhosts/$::sitename"",
  docroot_owner => $apache_user',
  docroot_group => $apache_user',
  options => ['-Indexes','+FollowSymLinks'],
  override => ['All'],
}

mysql::grant { 'drupal_mysql_user': 
  mysql_db => '*',
  mysql_user => $::sitename,
  mysql_password => $::sitename,
  mysql_create_db => false,
}
