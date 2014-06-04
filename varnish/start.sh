#!/bin/bash

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

export BACKEND_IP=$(   echo ${DRUPAL_PORT_80_TCP} | sed 's#tcp://##' | awk -F: '{ print $1 }' )
export BACKEND_PORT=$( echo ${DRUPAL_PORT_80_TCP} | sed 's#tcp://##' | awk -F: '{ print $2 }' )

echo "backend is at http://${BACKEND_IP}:${BACKEND_PORT}"

echo Varnish env vars...
env

# Start varnish and log
echo "starting varnish ..."
inject_environment /etc/varnish/default.vcl
varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT}
varnishlog