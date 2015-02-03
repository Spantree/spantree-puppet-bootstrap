#!/bin/bash

SCRIPT_ROOT=$(echo "$1")
PROJECT_ROOT=$(echo "$2")

OS=$(/bin/bash /tmp/os-detect.sh ID)
CODENAME=$(/bin/bash /tmp/os-detect.sh CODENAME)

export DEBIAN_FRONTEND=noninteractive

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

$(which git > /dev/null 2>&1)
FOUND_GIT=$?

if [ "$FOUND_GIT" -ne '0' ] && [ ! -f /var/puppet-init/librarian-puppet-installed ]; then
    $(which apt-get > /dev/null 2>&1)
    FOUND_APT=$?
    $(which yum > /dev/null 2>&1)
    FOUND_YUM=$?

    echo 'Installing git'

    if [ "${FOUND_YUM}" -eq '0' ]; then
        yum -y makecache
        yum -y install git
    else
        apt-get -q -y install git-core
    fi

    echo 'Finished installing git'
fi

if [[ ! -d "$PUPPET_DIR" ]]; then
    mkdir -p "$PUPPET_DIR"
    echo "Created directory $PUPPET_DIR"
fi

cp "$PROJECT_ROOT/puppet/Puppetfile" "$PUPPET_DIR"
echo "Copied Puppetfile"

if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
    if [[ ! -f /var/puppet-init/librarian-base-packages ]]; then
        echo 'Installing base packages for librarian'
        apt-get install -y build-essential ruby-dev 
        echo 'Finished installing base packages for librarian'

        touch /var/puppet-init/librarian-base-packages
    fi
fi

if [ "$OS" == 'ubuntu' ]; then
    if [ "$CODENAME" == 'precise' ] && [ ! -f /var/puppet-init/librarian-libgemplugin-ruby ]; then
        echo 'Updating libgemplugin-ruby (Ubuntu only)'
        apt-get install -y libgemplugin-ruby
        echo 'Finished updating libgemplugin-ruby (Ubuntu only)'

        touch /var/puppet-init/librarian-libgemplugin-ruby
    fi

    if [ "$CODENAME" == 'lucid' ] && [ ! -f /var/puppet-init/librarian-rubygems-update ]; then
        echo 'Updating rubygems (Ubuntu Lucid only)'
        echo 'Ignore all "conflicting chdir" errors!'
        gem install rubygems-update
        /var/lib/gems/1.8/bin/update_rubygems
        echo 'Finished updating rubygems (Ubuntu Lucid only)'

        touch /var/puppet-init/librarian-rubygems-update
    fi
fi

# we test for ruby after we have some cycle that installs at LEAST the ruby runtime
RUBYVER=$(ruby -e "print RUBY_VERSION")

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

cd "$PUPPET_DIR"

if [[ ! -f /var/puppet-init/librarian-puppet-installed ]]; then

    vercomp $RUBYVER 1.8.7
    RET=$?
    if [[ $RET -eq 0 ]]; then
        echo 'Installing librarian-puppet <1.1.0 because 1.1.x is not supported on ruby 1.8'
        gem install librarian-puppet -V -v"<1.1.0"
    else
        echo 'Installing librarian-puppet >1.1.x'
        gem install librarian-puppet -V -v">1.1.0" 
    fi
    echo 'Finished installing librarian-puppet'

    echo 'Running initial librarian-puppet'
    librarian-puppet install --clean
    echo 'Finished running initial librarian-puppet'

    touch /var/puppet-init/librarian-puppet-installed
else
    sha1sum -c /var/puppet-init/Puppetfile.sha1
    if [[ $? > 0 ]]
    then
        echo 'Running update librarian-puppet'
        librarian-puppet update
        echo 'Finished running update librarian-puppet'
    else
        echo 'Skipping librarian-puppet (Puppetfile unchanged)'
    fi
fi

sha1sum Puppetfile > /var/puppet-init/Puppetfile.sha1
