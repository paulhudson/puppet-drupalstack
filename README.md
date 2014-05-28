puppet-drupalstack
==================


###Initial Setup###

Clone repo and puppet deploy:

$ **git clone https://github.com/paulhudson/puppet-drupalstack.git && ~/puppet-drupalstack/shell/deploy.sh**

This will:

* git clone and run a build script
* install required packages via yum or apt-get
* ensure puppet module dependancies are met via puppet-libararies
* configure a Drupal LAMP stack via puppet
* install a test Drupal site

###Install More vhosts and Drupal sites###

You can quickly create a new apache vhost, mysql database and Drupal install with the shell/vhost_deploy.sh script.

To create a new Drupal site at mysite.tld simply pass that hostname as the -a flag:

$ **cd ~/puppet-drupalstack/shell**

$ **vhost_deploy.sh -a mysite.tld**

see: $ **vhost_deploy.sh --help**

###Manual###


Install dependancies and puppet librarian:

$ **shell/deploy.sh**

Apply puppet manifest:

$ **puppet apply init.pp**

Create a new vhost and mysql db:

$ **FACTER_sitename=hostname FACTER_db_user=dbuser FACTER_db_pass=dbpass puppet apply site.pp**
