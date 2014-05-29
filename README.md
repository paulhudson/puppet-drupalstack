puppet-drupalstack
==================


###Initial Setup###

Notes: 

* You **must** run this initial setup as root.
* The lib/*.sh deploy scripts currently assume the absolute location of /root/puppet-drupalstack/lib/\*.sh

Clone repo and puppet deploy:

$ **git clone https://github.com/paulhudson/puppet-drupalstack.git && ~/puppet-drupalstack/lib/deploy.sh**

This will:

* git clone and run a build script
* install required packages via yum or apt-get
* ensure puppet module dependancies are met via puppet-libararies
* configure a Drupal LAMP stack via puppet
* provide vhost+Drupal install utility

The vhost+Drupal install utility is accessible via command line and a web interface, see below.


###Install More vhosts and Drupal sites###

You can quickly create a new apache vhost, mysql database and Drupal install with the lib/vhost_deploy.sh script.

To create a new Drupal site at mysite.tld simply pass that hostname as the -a flag:

$ **cd ~/puppet-drupalstack**

$ **lib/vhost_deploy.sh -a mysite.tld**

You can optionally install a Drupal distribution by using the -d flag:

$ **lib/vhost_deploy.sh -a mysite.tld -d commerce_kickstart**

see: $ **lib/vhost_deploy.sh --help**

###Manual Setup###

The main steps in the inital automated setup are avalible for advanced users once you've cloned the repo:

$ **cd ~/puppet-drupalstack**

Install dependancies and puppet librarian:

$ **lib/deploy.sh**

Apply puppet manifest:

$ **puppet apply init.pp**

Create a new vhost and mysql db:

$ **FACTER_sitename=hostname FACTER_db_user=dbuser FACTER_db_pass=dbpass puppet apply site.pp**
