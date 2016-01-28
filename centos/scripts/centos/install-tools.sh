#!/bin/bash -eux

printf '%s\n' "Installing git kernel-devel gcc perl for vbguest update"
yum install -y git kernel-devel gcc perl
