# Atomic repo
class { 'atomic': }

# PHP
class { 'php': }

package { ['ImageMagick', 'php-pecl-memcached', 'memcached', 'php-pecl-apc', 'php-process' ]:
  ensure => 'installed',
}

$phpModules = [ 'mysql', 'cli', 'intl', 'mcrypt', 'gd', 'xml']
php::module { $phpModules: }

file { [ "/etc/php.d", "/etc/php.d/conf.d", "/etc/php.d/cli", "/etc/php.d/cli/conf.d"]:
  ensure => "directory",
  require => Package['php'],
}

php::ini { 'php':
  value   => ['memory_limit = 256M'],
  require => Package['php'],
}

# Apache
class { 'apache': 
  #default_vhost => false,
}

#class { 'apache::mod::php': }
#class { 'apache::mod::ssl': }
#include 'apache::mod::php'
#include 'apache::mod::ssl'
#class {'::apache::mod::php': }
#class {'::apache::mod::ssl': }
#apache::mod { 'php': }
#apache::mod { 'ssl': }
#class {'apache::mod::php':
#  path         => "${::apache::params::lib_path}/libphp5.so",
#}
class {'apache::mod::ssl': }
class {'apache::mod::php': }



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
     
file {[ "/var/www", "/var/www/vhosts" ]:
  ensure => "directory",
  owner => $apache_user,
  group => $apache_user,
  mode => 750,
  require => Package[$apache],
}

file {[ "/var/log/drupal-install" ]:
  ensure => "present",
  owner => $apache_user,
  group => $apache_user,
  mode => 755,
  require => Package[$apache],
}

apache::vhost { 'mysite.com':
  port          => '8080',
  docroot       => '/var/www/vhosts/mysite.com',
  docroot_owner => $apache_user,
  docroot_group => $apache_user,
  options => ['-Indexes','+FollowSymLinks'],
  override => ['All'],
}

# Pear
class { 'pear': }

# mysql
class { 'mysql': }

#mysql::grant { 'drupal_mysql_user': 
#  mysql_db => '*',
#  mysql_user => 'drupal',
#  mysql_password => 'drupal',
#  mysql_create_db => false,
#}

# Drush
class { 'drush': }

# Sudoers
#Install sudo package
package { 'sudo':
  ensure => installed, # ensure sudo package installed
}

# Allow users belonging apache group to use sudo
/*
augeas { 'sudo_daemonize':
    context => '/files/etc/sudoers', # target file is /etc/sudoers
    changes => [
        # allow wheel users to use sudo
        'set spec[last() + 1]/user %apache',
        'set spec[last()]/host_group/host ALL',
        'set spec[last()]/host_group/command /root/puppet-drupalstack/lib/daemonize.php',
        'set spec[last()]/host_group/command/runas_user ALL',
        'set spec[last()]/host_group/command/tag NOPASSWD',       
        
        # Don't require tty
        'set Defaults[type=":root"]/type :root',
        'set Defaults[type=":root"]/requiretty/negate ""',
        'set Defaults[type=":root"]/visiblepw/negate ""',
        
        # Don't require tty
        'set Defaults[type=":apache"]/type :apache',
        'set Defaults[type=":apache"]/requiretty/negate ""',
        'set Defaults[type=":apache"]/visiblepw/negate ""',
        
    ],
    #require => User["$apache_user"],
}
augeas { 'sudo_php':
    context => '/files/etc/sudoers', # target file is /etc/sudoers
    changes => [
        # allow apache users to use sudo
        'set spec[last() + 1]/user %apache',
        'set spec[last()]/host_group/host ALL',
        'set spec[last()]/host_group/command /usr/bin/php',
        'set spec[last()]/host_group/command/runas_user ALL',
        'set spec[last()]/host_group/command/tag NOPASSWD',
              
    ],
    #require => User["$apache_user"],
}


# Better than sudoers...
file { "/root/puppet-drupalstack/lib/vhost_deploy.sh":
  group => "$apache_user",
  require => User["$apache_user"],
}

# vhost_deploy interfact
file { "/var/www/html/index.php":
    mode   => 644,
    owner  => $apache_user,
    group  => $apache_user,
    source => "/root/puppet-drupalstack/files/drupal-install/index.php",
    require => User["$apache_user"],
}
file { "/var/www/html/global.css":
    mode   => 644,
    owner  => $apache_user,
    group  => $apache_user,
    source => "/root/puppet-drupalstack/files/drupal-install/global.css",
    require => User["$apache_user"],
}
*/

# Drupal
/*
include drupal

drupal::core { '7.21':
  version => 'latest',
  path => '/var/www/vhosts/drupal.test',
  require => Package['php', 'mysql', 'httpd', 'drush'],
}
*/
