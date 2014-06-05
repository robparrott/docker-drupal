#!/bin/bash

source /etc/profile

#
# Takes tokens of form ${VARNAME} in a file and injects actual env var value
#
function inject_environment {

  envs=`printenv`
  for envvar in $envs; do
    IFS== read name value <<< "${envvar}"
    sed -i "s|\${${name}}|${value}|g" $1
  done
}

if [ ! -f /var/www/sites/default/settings.php ]; then

    export MYSQL_HOST=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $1 }' )
    export MYSQL_PORT=$( echo ${DB_PORT} | sed 's#tcp://##' | awk -F: '{ print $2 }' )

    export MEMCACHE_HOST=$( echo ${MEMCACHED_PORT} | sed 's#tcp://##' | awk -F: '{ print $1 }' )
    export MEMCACHE_PORT=$( echo ${MEMCACHED_PORT} | sed 's#tcp://##' | awk -F: '{ print $2 }' )


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

	# Install Drupal
	DB_URL="mysqli://drupal:${MYSQL_PASSWORD}@${MYSQL_HOST}:${MYSQL_PORT}/drupal"
    echo MySQL connection string: ${DB_URL}

    echo "Running Drush ..."
    cd /var/www/html/
	drush site-install standard -y --site-name="Twelve Factor Drupal" --account-name=admin --account-pass=admin --db-url="${DB_URL}" 
#    drush -y en memcache
#    drush -y en memcache_admin

    inject_environment /tmp/settings.php.memcache
#    cat /tmp/settings.php.memcache >> /var/www/html/sites/default/settings.php

    echo

fi

