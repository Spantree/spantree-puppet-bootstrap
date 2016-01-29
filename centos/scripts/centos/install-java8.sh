#!/bin/bash -eux

pushd /tmp

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-x64.rpm" -O jdk-linux-x64.rpm

rpm -ivh jdk-linux-x64.rpm

(
cat <<'EOF'
#!/usr/bin/env bash

export JAVA_HOME=/usr/java/jdk1.8.0_71

export PATH="/usr/local/bin:${JAVA_HOME}/bin:${PATH}"

EOF
) > /etc/profile.d/java.sh

chmod a+x /etc/profile.d/java.sh

rm -rf jdk-linux-x64.rpm

popd
