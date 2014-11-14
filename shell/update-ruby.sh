#!/bin/bash

SCRIPT_ROOT=$(echo "$1")
RUBY_VERSION=${2:-1.9.1}

OS=$(/bin/bash $SCRIPT_ROOT/os-detect.sh ID)
RELEASE=$(/bin/bash $SCRIPT_ROOT/os-detect.sh RELEASE)
CODENAME=$(/bin/bash $SCRIPT_ROOT/os-detect.sh CODENAME)

FLAG_ROOT=/var/puppet-bootstrap

if [[ ! -f "#{FLAG_ROOT}/install-ruby-${RUBY_VERSION}" ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    	echo "Installing Ruby ${RUBY_VERSION}"
    	apt-get install -y "ruby${RUBY_VERSION}-dev"
    	touch "#{FLAG_ROOT}/install-ruby-${RUBY_VERSION}"
    	echo "Finished install Ruby ${RUBY_VERSION}"
    elif [[ "${OS}" == 'centos' ]]; then
        echo "Sorry, CentOS Ruby installation is not yet supported"
   	fi
fi