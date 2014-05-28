#!/bin/sh

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum
$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?
$(which yum > /dev/null 2>&1)
FOUND_YUM=$?

$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
echo 'Attempting to install git.'

if [ "${FOUND_YUM}" -eq '0' ]; then
yum -q -y makecache
yum -q -y install git
echo 'git installed.'
elif [ "${FOUND_APT}" -eq '0' ]; then
apt-get -q -y update
apt-get -q -y install git
echo 'git installed.'
else
echo 'No package installer available. You may need to install git manually.'
fi
else
echo 'git found.'
fi

if [ ! -d "$PUPPET_DIR" ]; then
mkdir -p $PUPPET_DIR
fi

# cp Puppetfile with puppet librarian definitions
cp ~/puppet-drupalstack/puppet/Puppetfile $PUPPET_DIR

echo 'Installing puppet.'

if [ "${FOUND_YUM}" -eq '0' ]; then
#Install puppet
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
echo 'added puppet yum repo.'

# Install Puppet:
#sudo yum install puppet-server
yum -q -y install puppet

elif [ "${FOUND_APT}" -eq '0' ]; then

wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
echo 'added puppet apt repo.'

# Install Puppet:
#sudo apt-get -q -y install puppet-server
sudo apt-get -q -y install puppet
fi

echo "Installing librarian-puppet"
if [ "$(gem list -i '^librarian-puppet$')" = "false" ]; then
gem install librarian-puppet
cd $PUPPET_DIR && librarian-puppet install --clean
else
cd $PUPPET_DIR && librarian-puppet update
fi

# Run puppet init.pp
puppet apply ~/puppet-drupalstack/init.pp

# Install test Drupal site
cd /var/www/vhosts/drupal.test
drush dl drupal --drupal-project-rename=drupal
chown -R apache:apache ./drupal && cd drupal
drush site-install standard --db-url=mysql://drupal:drupal@localhost/drupal --site-name=Drupal Test -y


# set PATH or bash_profile alias, etc for vhosts/drupal installer sh

# Display some help
echo " "
echo "Your server has been configured to run Drupal."
echo " "
echo "To setup more Drupal sites simply run 'vhost_deploy.sh' form command line"
echo ""
echo "For help, see: vhost_deploy.sh --help"
echo ""
