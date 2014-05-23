# Atomic repo
class { 'atomic': }

# Apache
 class { 'apache':}
 
 apache::module { 'rewrite': }

 include apache::ssl
 
file { [ "/var/www", "/var/www/vhosts" ]:
  ensure => "directory",
  owner => 'apache',
  group => 'apache',
  mode => 750,
  require => Package['httpd'],
}

 apache::vhost { 'drupal.test':
   docroot  => '/var/www/vhosts/drupal.test',
   docroot_create => true,
   directory_allow_override   => 'All',
   ssl => true,
   server_name => 'drupal.test',
}

# PHP
class { 'php': }

package { ['ImageMagick', 'php-pecl-memcached', 'memcached', 'php-pecl-apc' ]:
  ensure => 'installed',
}

$phpModules = [ 'mysql', 'cli', 'intl', 'mcrypt', 'gd']
php::module { $phpModules: }

file { [ "/etc/php.d", "/etc/php.d/conf.d", "/etc/php.d/cli", "/etc/php.d/cli/conf.d"]:
  ensure => "directory",
  require => Package['php'],
}

php::ini { 'php':
  value   => ['memory_limit = "256M"'],
  require => Package['php'],
}

# Pear
class { 'pear': }

# mysql
class { 'mysql': }

# Drush

# Drupal
class { 'drupal': }

drupal::core { 'drupal.test':
  path => '/var/www/vhosts/drupal.test',
  require => Package['php', 'mysql', 'httpd', 'drush'],
}
