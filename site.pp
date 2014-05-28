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

# Apache
class { 'apache': }
class {'apache::mod::ssl': }
class {'apache::mod::php': }

apache::vhost { $::sitename:
  port          => '80',
  docroot       => "/var/www/vhosts/$::sitename",
  docroot_owner => $apache_user,
  docroot_group => $apache_user,
  options => ['-Indexes','+FollowSymLinks'],
  override => ['All'],
}

# Generate a mysql password and create DB user


mysql::grant { $::db_user: 
  mysql_user => $::db_user,
  mysql_password => $::db_pass,
}
