#!/bin/bash

# Set Drupal based on env vars
/setup.sh

# Setup SSH access
#cat /etc/ssh/sshd_config
echo ${SSH_PUB_KEY} >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# start daemons
supervisord -n
