# Spantree Puppet Bootstrap

These are a set of scripts we run to bootstrap a Vagrant/Packer/AWS image with the provisioning toolchain we like to use.

It is loosely based off of the shell scripts originally provided by the [Puphpet](https://puphpet.com/) project, but we've taken a few liberties:

* We use [r10k] instead of [librarian-puppet] due to frequent Ruby versioning issues.
* We parameterize the base path of the shell scripts so we can execute them in non-Vagrant environments.