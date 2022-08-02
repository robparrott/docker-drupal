FROM    ubuntu:14.04@sha256:d7a459ecd77ebb09525584f2c3e1bb7f6a2879d90df8a3523c1b899dfc2a226f 


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

# Retrieve drupal & setup dirs for it
RUN rm -rf /var/www/html ; cd /var ; drush dl drupal ; mv /var/drupal*/ /var/www/html
RUN chmod a+w /var/www/html/sites/default ; mkdir /var/www/html/sites/default/files ; chown -R www-data:www-data /var/www/

# Setup apache
ADD ./default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite vhost_alias

# Setup SSHd so we can login and debug
RUN DEBIAN_FRONTEND=noninteractive  apt-get install -y zip unzip openssh-server
RUN mkdir -p /var/run/sshd && mkdir /root/.ssh && chmod 700 /root/.ssh

EXPOSE 80
#CMD ["/usr/bin/supervisord"]
CMD ["bash", "/start.sh"]