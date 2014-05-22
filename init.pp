 class { 'apache':}

 apache::vhost { 'mysite':
   docroot  => '/var/www/vhosts',
 }