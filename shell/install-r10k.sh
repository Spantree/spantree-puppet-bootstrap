#!/bin/bash

SCRIPT_ROOT=$(echo "$1")

OS=$(/bin/bash $SCRIPT_ROOT/os-detect.sh ID)
CODENAME=$(/bin/bash $SCRIPT_ROOT/os-detect.sh CODENAME)

# Directory in which r10k should manage its modules directory
PUPPET_DIR=/etc/puppet/

$(which git > /dev/null 2>&1)
FOUND_GIT=$?

if [ "$FOUND_GIT" -ne '0' ] && [ ! -f "${FLAG_ROOT}/git-installed" ]; then
    $(which apt-get > /dev/null 2>&1)
    FOUND_APT=$?
    $(which yum > /dev/null 2>&1)
    FOUND_YUM=$?

    echo 'Installing git'

    if [ "${FOUND_YUM}" -eq '0' ]; then
        yum -q -y makecache
        yum -q -y install git
    else
        apt-get -q -y install git-core >/dev/null
    fi

    echo 'Finished installing git'

    touch "${FLAG_ROOT}/git-installed"
fi

if [[ ! -d "$PUPPET_DIR" ]]; then
    mkdir -p "$PUPPET_DIR"
    echo "Created directory $PUPPET_DIR"
fi

cp "$SCRIPT_ROOT/../puppet/Puppetfile" "$PUPPET_DIR"
echo "Copied Puppetfile"

if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
    if [[ ! -f "${FLAG_ROOT}/r10k-base-packages" ]]; then
        echo 'Installing base packages for r10k'
        apt-get install -y build-essential ruby-dev >/dev/null
        echo 'Finished installing base packages for r10k'

        touch "${FLAG_ROOT}/r10k-base-packages"
    fi
fi

if [ "$OS" == 'ubuntu' ]; then
    if [ "$CODENAME" == 'lucid' ] && [ ! -f "${FLAG_ROOT}/r10k-rubygems-update" ]; then
        echo 'Updating rubygems (Ubuntu Lucid only)'
        echo 'Ignore all "conflicting chdir" errors!'
        gem install rubygems-update >/dev/null
        /var/lib/gems/1.8/bin/update_rubygems >/dev/null
        echo 'Finished updating rubygems (Ubuntu Lucid only)'

        touch "${FLAG_ROOT}/r10k-rubygems-update"
    fi
fi

if [[ ! -f "${FLAG_ROOT}/r10k-installed" ]]; then
    echo 'Installing r10k'
    gem install bundler > /dev/null 
    gem install r10k >/dev/null
    echo 'Finished installing r10k'

    echo 'Running initial r10k install'
    cd /etc/puppet/
    r10k puppetfile install  --verbose
    echo 'Finished running r10k install'

    touch "${FLAG_ROOT}/r10k-installed"
else
    cd /etc/puppet/
    
    if [[ -f "${FLAG_ROOT}/Puppetfile.sha1" ]]; then
        sha1sum -c "${FLAG_ROOT}/Puppetfile.sha1" >/dev/null
    else
        cat "${FLAG_ROOT}/Puppetfile.sha1" &> /dev/null
    fi

    if [[ $? > 0 ]]
    then
        echo 'Running r10k install'
        cd "$PUPPET_DIR"
        r10k puppetfile install --verbose
        echo 'Finished running r10k install'
        sha1sum Puppetfile > "${FLAG_ROOT}/Puppetfile.sha1"
    else
        echo 'Skipping r10k install (Puppetfile unchanged)'
    fi
fi