# Atomic repo
class { 'atomic': }

# PHP
class { 'php': }

package { ['ImageMagick', 'php-pecl-memcached', 'memcached', 'php-pecl-apc' ]:
  ensure => 'installed',
}

$phpModules = [ 'mysql', 'cli', 'intl', 'mcrypt', 'gd', 'xml']
php::module { $phpModules: }

file { [ "/etc/php.d", "/etc/php.d/conf.d", "/etc/php.d/cli", "/etc/php.d/cli/conf.d"]:
  ensure => "directory",
  require => Package['php'],
}

php::ini { 'php':
  value   => ['memory_limit = "256M"'],
  require => Package['php'],
}

# Apache
class { 'apache': 
  default_vhost => false,
}

class { 'apache::default_mods': } 
#class { 'apache::mod::ssl': }
 
file { [ "/var/www", "/var/www/vhosts" ]:
  ensure => "directory",
  owner => 'apache',
  group => 'apache',
  mode => 750,
  require => Package['httpd'],
}

apache::vhost { 'drupal.test':
  port          => '80',
  docroot       => '/var/www/vhosts/drupal.test',
  docroot_owner => 'apache',
  docroot_group => 'apache',
  options => ['-Indexes','+FollowSymLinks'],
  override => ['All'],
}

# Pear
class { 'pear': }

# mysql
class { 'mysql': }

mysql::grant { 'drupal_mysql_user': 
  mysql_db => '*',
  mysql_user => 'drupal',
  mysql_password => 'drupal',
  mysql_create_db => false,
}

# Drush

# Drupal
/*
include drupal

drupal::core { '7.21':
  version => 'latest',
  path => '/var/www/vhosts/drupal.test',
  require => Package['php', 'mysql', 'httpd', 'drush'],
}
*/
