#!/bin/bash

SCRIPT_ROOT=$(echo "$1")

OS=$(/bin/bash $SCRIPT_ROOT/os-detect.sh ID)
CODENAME=$(/bin/bash $SCRIPT_ROOT/os-detect.sh CODENAME)

FLAG_ROOT=/var/puppet-bootstrap

if [[ ! -d "$FLAG_ROOT" ]]; then
    mkdir -p "$FLAG_ROOT"
    echo "Created directory $FLAG_ROOT"

    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
        sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
    fi
fi

if [[ ! -f "${FLAG_ROOT}/initial-setup-repo-update" ]]; then
    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
        echo "Running initial-setup apt-get update"
        apt-get update
        touch "${FLAG_ROOT}/initial-setup-repo-update"
        echo "Finished running initial-setup apt-get update"
    elif [[ "$OS" == 'centos' ]]; then
        echo "Running initial-setup yum update"
        yum update -y >/dev/null
        echo "Finished running initial-setup yum update"

        echo "Installing basic development tools (CentOS)"
        yum -y groupinstall "Development Tools" >/dev/null
        echo "Finished installing basic development tools (CentOS)"
        touch "${FLAG_ROOT}/initial-setup-repo-update"
    fi
fi

if [[ "$OS" == 'ubuntu' && ! -f "${FLAG_ROOT}/ubuntu-required-libraries" ]]; then
    echo 'Installing basic curl packages (Ubuntu only)'
    apt-get install -y curl unzip libcurl3 build-essential libcurl4-gnutls-dev >/dev/null
    echo 'Finished installing basic curl packages (Ubuntu only)'

    touch "${FLAG_ROOT}/ubuntu-required-libraries"
fi