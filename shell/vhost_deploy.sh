aliasflag=''
helpflag='false'

while getopts 'a:h' flag; do
case "${flag}" in
a) aliasflag="${OPTARG}" ;;
h) helpflag='true' ;;
*) error "Unexpected option ${flag}" ;;
esac
done

if [ $helpflag == 'true' ]; then
echo " "
echo "Add new vhost and Drupal install"
echo " "
echo "options:"
echo "-h, --help                show this help"
echo "-a                        alias hostname for the new site, e.g. drupal.test"
exit 0
fi

if [ $aliasflag == '' ]; then
echo "alias -a must be supplied, see -h for help"
exit 0
fi

FACTER_sitename=$aliasflag puppet apply site.pp

# Install test Drupal site
cd /var/www/vhosts/$aliasflag
drush dl drupal --drupal-project-rename=$aliasflag
chown -R apache:apache ./$aliasflag && mv -r ./$aliasflag ./
drush site-install standard --db-url=mysql://$aliasflag:$aliasflag@localhost/$aliasflag --site-name=Drupal Test -y


# set PATH or bash_profile alias, etc for vhosts/drupal installer sh

# Display some help
echo " "
echo "Your server has been configured to run Drupal and a test site created."
echo " "
echo "Login to: http://$aliasflag (ensure $aliasflag resolves to server IP)"
echo ""
echo "To setup more Drupal sites simply run 'drupal-install' form command line"
echo ""
echo "For help, see: vhost-deploy.sh --help"
echo ""
