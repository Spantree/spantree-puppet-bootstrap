#!/bin/bash

OS=$(/bin/bash /tmp/os-detect.sh ID)
CODENAME=$(/bin/bash /tmp/os-detect.sh CODENAME)
RELEASE=$(/bin/bash /tmp/os-detect.sh RELEASE)

export DEBIAN_FRONTEND=noninteractive

PUPPET_VERSION=$(echo "$3")

if [[ ! -f /var/puppet-init/update-puppet ]]; then
    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
       # if [ "$RELEASE" == 'precise' ]; then
            echo "Downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
            wget --quiet --tries=5 --timeout=10 -O "/var/puppet-init/puppetlabs-release-${CODENAME}.deb" "http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
            echo "Finished downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"

            dpkg -i "/var/puppet-init/puppetlabs-release-${CODENAME}.deb" > /dev/null
       # fi

        echo "Running update-puppet apt-get update"
        apt-get update
        echo "Finished running update-puppet apt-get update"

        if [ -z "$PUPPET_VERSION" ];
        then
            echo "Updating Puppet to latest version"
            apt-get -y install puppet
            PUPPET_VERSION=$(puppet help | grep 'Puppet v')
        else
            echo "Updating Puppet to version ${PUPPET_VERSION}"
            apt-get -y install puppet="${PUPPET_VERSION}" puppet-common="${PUPPET_VERSION}"

        fi
        echo "Finished updating puppet to version: $PUPPET_VERSION"

        touch /var/puppet-init/update-puppet
        echo "Created empty file /var/puppet-init/update-puppet"
    elif [ "$OS" == 'centos' ]; then
        echo "Downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"
        yum -y --nogpgcheck install "http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm" >/dev/null
        echo "Finished downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"

        echo "Running update-puppet yum update"
        yum -y update >/dev/null
        echo "Finished running update-puppet yum update"

        if [ -z "$PUPPET_VERSION" ];
        then
            echo "Updating Puppet to latest version"
            yum -y install puppet >/dev/null
            PUPPET_VERSION=$(puppet help | grep 'Puppet v')
        else
            echo "Updating Puppet to version ${PUPPET_VERSION}"
            yum -y install "puppet-${PUPPET_VERSION}" >/dev/null
        fi
        echo "Finished updating puppet to version: $PUPPET_VERSION"

        touch /var/puppet-init/update-puppet
        echo "Created empty file /var/puppet-init/update-puppet"
    fi
fi
