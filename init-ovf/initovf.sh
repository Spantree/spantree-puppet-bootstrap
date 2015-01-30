#!/usr/bin/env bash


for distro in `\find . -maxdepth 1 -mindepth 1 -type d`; do
  pushd ${distro} > /dev/null
  for release in `\find . -maxdepth 1 -mindepth 1 -type d`; do
    pushd ${release} > /dev/null
    vagrant up && vagrant destroy -f
    popd
  done
  popd
done
