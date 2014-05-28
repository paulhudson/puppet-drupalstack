aliasflag=''
helpflag='false'
distribution='drupal'

while getopts 'a:h:d' flag; do
case "${flag}" in
a) aliasflag="${OPTARG}" ;;
d) distribution="${OPTARG}" ;;
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
echo "-a                        alias - hostname for the new site, e.g. drupal.test"
echo "-d                        distribution - the Drupal distribution you want to install (default: drupal)"
exit 0
fi


if [ $aliasflag == '' ]; then
  echo "alias -a must be supplied, see -h for help"
  exit 0
fi

db_pass=$(date +”%N” | md5sum | base64 | head -c 16)
db_user=$(echo $aliasflag | tr -dc _A-Z-a-z-0-9 | head -c6 ;)

FACTER_sitename=$aliasflag FACTER_db_user=$db_user FACTER_db_pass=$db_pass puppet apply site.pp

cd /var/www/vhosts/$aliasflag
drush dl $distribution --drupal-project-rename=$db_user
chown -R apache:apache ./$db_user && mv ./$db_user/* ./ && rm -rf ./$db_user
drush site-install $distribution --db-url=mysql://$db_user:$db_pass@localhost/$db_user --site-name=$aliasflag -y


# set PATH or bash_profile alias, etc for vhosts/drupal installer sh

# Display some help
echo " "
echo "Login at: http://$aliasflag (ensure $aliasflag resolves to server IP)"
echo ""
echo "Make a note of your MySQL password: $db_pass for user $db_user"
echo ""
echo "To setup more Drupal sites simply run 'vhost_deploy.sh' form command line"
echo ""
echo "For help, see: vhost-deploy.sh --help"
echo ""
