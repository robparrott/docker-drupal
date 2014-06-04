#!/bin/bash

source /etc/profile

if [ ! -f /var/www/sites/default/settings.php ]; then

    MYSQL_HOST=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $1 }' )
    MYSQL_PORT=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $2 }' )



	# Generate random passwords 
	#DRUPAL_DB="drupal"
	#MYSQL_PASSWORD=""
	#DRUPAL_PASSWORD=`pwgen -c -n -1 12`
	# This is so the passwords show up in logs. 
	echo drupal password: "$MYSQL_PASSWORD"
	echo "$MYSQL_PASSWORD"  > /mysql-root-pw.txt
	echo "$DRUPAL_PASSWORD" > /drupal-db-pw.txt
#	mysqladmin -u root password "$MYSQL_PASSWORD" 



    MYSQL_PASSWORD_ARG=
    if ! [ -z ${MYSQL_ROOT_PASSWORD} ]; then
    	MYSQL_PASSWORD_ARG="-p${MYSQL_ROOT_PASSWORD}"
    fi
    echo "creating dataase for drupal ..."
    mysql -u root -h ${MYSQL_HOST} ${MYSQL_PASSWORD_ARG} -e "CREATE DATABASE drupal;"

    echo "granting access for drupal user ... "
	mysql -u root -h ${MYSQL_HOST} ${MYSQL_PASSWORD_ARG} -e "GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'%';  FLUSH PRIVILEGES;"

    echo "setting the password for the drupal user ... "
	mysql -u root -h ${MYSQL_HOST} ${MYSQL_PASSWORD_ARG} -e "SET PASSWORD FOR 'drupal'@'%' = PASSWORD('${MYSQL_PASSWORD}');"

#	mysql -u root -h 127.0.0.1 -p"$MYSQL_PASSWORD" -e "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"
	
	sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/default
	a2enmod rewrite vhost_alias
	cd /var/www/
	DB_URL="mysqli://drupal:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/drupal"
    echo MySQL connection string: ${DB_URL}

    echo "Running Drush ..."
	drush site-install standard -y --account-name=admin --account-pass=admin --db-url="${DB_URL}" 
fi

