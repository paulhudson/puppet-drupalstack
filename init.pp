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

package { 'ImageMagick':
  ensure => 'installed',
}

$phpModules = [ 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache', 'gd', 'apc']
php::module { $phpModules: }

file { [ "/etc/php.d", "/etc/php.d/conf.d", "/etc/php.d/cli", "/etc/php.d/cli/conf.d"]:
  ensure => "directory",
}

php::ini { 'php':
  value   => ['memory_limit = "256M"'],
}
