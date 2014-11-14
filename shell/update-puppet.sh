#!/bin/bash

SCRIPT_ROOT=${1}
PUPPET_VERSION=${2:-3.4.3}

OS=$(/bin/bash $SCRIPT_ROOT/os-detect.sh ID)
RELEASE=$(/bin/bash $SCRIPT_ROOT/os-detect.sh RELEASE)
CODENAME=$(/bin/bash $SCRIPT_ROOT/os-detect.sh CODENAME)

FLAG_ROOT=/var/puppet-bootstrap

if [[ -f "${FLAG_ROOT}/install-puppet" ]]; then
    exit 0
else
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        apt-get -y install augeas-tools libaugeas-dev
    elif [[ "${OS}" == 'centos' ]]; then
        yum -y install augeas-devel
    fi

    echo 'Installing Puppet requirements'
    /usr/bin/gem install haml hiera facter json ruby-augeas --no-rdoc --no-ri
    echo 'Finished installing Puppet requirements'

    echo "Installing Puppet ${PUPPET_VERSION}"
    /usr/bin/gem install puppet --version "${PUPPET_VERSION}" --no-rdoc --no-ri

    echo "Finished installing Puppet ${PUPPET_VERSION}"

    touch "${FLAG_ROOT}/install-puppet"
fi