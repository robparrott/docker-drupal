FROM    ubuntu:14.04 


#RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main restricted universe multiverse" > /etc/apt/sources.list
RUN apt-get update
#RUN apt-get -y upgrade

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl  

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git mysql-client apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql php-apc php5-gd php5-curl php5-memcache memcached drush mc
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean

# Put build and run scripts in place
RUN easy_install supervisor
ADD ./setup.sh /setup.sh
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
RUN chmod 755 /start.sh /setup.sh /etc/apache2/foreground.sh

# Retrieve drupal
RUN rm -rf /var/www/ ; cd /var ; drush dl drupal ; mv /var/drupal*/ /var/www/
RUN chmod a+w /var/www/sites/default ; mkdir /var/www/sites/default/files ; chown -R www-data:www-data /var/www/

# Setup SSHd so we can login and debug
RUN DEBIAN_FRONTEND=noninteractive  apt-get install -y zip unzip openssh-server
RUN mkdir -p /var/run/sshd && mkdir /root/.ssh && chmod 700 /root/.ssh

EXPOSE 80
#CMD ["/usr/bin/supervisord"]
CMD ["bash", "/start.sh"]