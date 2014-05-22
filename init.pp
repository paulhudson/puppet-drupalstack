 # Apache
 class { 'apache':}
 
 apache::module { 'rewrite': }

 include apache::ssl
 
file { "/var/www/vhosts":
  ensure => "directory",
  owner => 'httpd',
  group => 'httpd',
  mode => 750,
}

 apache::vhost { 'drupal':
   docroot  => '/var/www/vhosts/drupal',
   docroot_create => true,
   directory_allow_override   => 'All',
   ssl => true,
   server_name => 'drupal',
}

# PHP
class { 'php': }

$phpModules = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache', 'gd', 'apc']
php::module { $phpModules: }

php::ini { 'php':
  value   => ['memory_limit = "256M"'],
  target  => 'php.ini',
  service => 'apache',
}