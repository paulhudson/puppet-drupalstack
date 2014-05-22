 class { 'apache':}

 apache::vhost { 'mysite':
   docroot  => '/var/www/vhosts',
   template => 'example42/apache/vhost/mysite.com.erb',
 }