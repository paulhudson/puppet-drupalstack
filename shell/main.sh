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
cp puppet/Puppetfile $PUPPET_DIR

if [ "${FOUND_YUM}" -eq '0' ]; then
#Install puppet
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
echo 'added puppet yum repo.'

echo 'Installing puppet.'
#Puppet Master:
#sudo yum install puppet-server

#Puppet Nodes:
yum -q -y install puppet

fi

if [ "$(gem list -i '^librarian-puppet$')" = "false" ]; then
gem install librarian-puppet
cd $PUPPET_DIR && librarian-puppet install --clean
else
cd $PUPPET_DIR && librarian-puppet update
fi

puppet apply init.pp
