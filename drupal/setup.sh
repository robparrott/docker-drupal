#!/bin/bash

source /etc/profile

if [ ! -f /var/www/sites/default/settings.php ]; then

	# Generate random passwords 
	DRUPAL_DB="drupal"
	MYSQL_PASSWORD=""
	DRUPAL_PASSWORD=`pwgen -c -n -1 12`
	# This is so the passwords show up in logs. 
	echo mysql root password: "$MYSQL_PASSWORD"
	echo drupal password: "$DRUPAL_PASSWORD"
	echo "$MYSQL_PASSWORD"  > /mysql-root-pw.txt
	echo "$DRUPAL_PASSWORD" > /drupal-db-pw.txt
#	mysqladmin -u root password "$MYSQL_PASSWORD" 

    MYSQL_HOST=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $1 }' )
    MYSQL_PORT=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $2 }' )

	DB_URL="mysqli://drupal:${DRUPAL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/drupal"

    env

	mysql -u root -h ${MYSQL_HOST} -e "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY '${DRUPAL_PASSWORD}; FLUSH PRIVILEGES;"
#	mysql -u root -h 127.0.0.1 -p"$MYSQL_PASSWORD" -e "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"
	
	# sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/default
	# a2enmod rewrite vhost_alias
	# cd /var/www/
	# DB_URL="mysqli://drupal:${DRUPAL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/drupal" 
	# drush site-install standard -y --account-name=admin --account-pass=admin --db-url="${DB_URL}" 
fi

