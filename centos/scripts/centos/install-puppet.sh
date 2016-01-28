#!/bin/bash -eux

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

yum repolist | grep puppet

yes | yum -y install puppet

gem install --no-rdoc --no-ri -V librarian-puppet


