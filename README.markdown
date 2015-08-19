# accounts

#### Table of Contents
1. [Description](#description)
2. [Setup - The basics of getting started with accounts](#setup)
    * [What accounts affects](#what-accounts-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [modulename]](#beginning-with-[modulename])
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Description

The accounts module manages resources related to login and service accounts
for Puppet Enterprise. This module replaces Puppet Enterprise's built-in pe\_accounts module, which was removed from PE 2015.3 and later.

This module is designed to work on all PE-supported Unix operating systems.
This module does not currently support configuring accounts on Microsoft
Windows platforms.

## Setup

### What accounts affects **OPTIONAL**


### Setup Requirements **OPTIONAL**


### Install the accounts module

This module should be placed in your module search path. The module is
designed to be automatically updated with Puppet Enterprise updates and should
not be modified.

### Quick Start

With the module installed, simply declare the accounts class in a Puppet
managed node's catalog:

~~~puppet
node default {
  accounts::user { 'dan': }
  accounts::user { 'jeff': }
}
~~~

The above example will create accounts, home directories, and groups for Jeff
and Dan.

## Usage

### Declare user accounts

The accounts::user defined resource type supports most of the major features
the user native type supports (see $ puppet describe user) and the additional
parameters of locked and sshkeys.

Examples of declaring resources are provided in the examples/ sub directory of
this module.

### Customize the home directory

If the account being managed is using the Bash shell, a simple bashrc and
bash\_profile rc file will be managed by Puppet for each account.  These rc
files will read the following files in the following order, which are not
automatically managed by Puppet:

 1. /etc/bashrc
 2. /etc/bashrc.puppet
 3. ~/.bashrc.custom

Each account holder may customize their shell by managing the bashrc.custom
file.  In addition, the system administrator may easily make profile changes
that affect all accounts with a shell of bash by managing the
/etc/bashrc.puppet file.

### Lock accounts

Accounts managed with this module can be locked by setting the "locked"
property of an account to true.

For example:

~~~puppet
accounts::user { 'villain':
  comment => 'Bad Person',
  locked  => true
}
~~~

The accounts module will set the account to an invalid shell appropriate for
the system Puppet is managing.

~~~
$ ssh villain@centos56
This account is currently not available.
Connection to 172.16.214.129 closed.
~~~

### Manage SSH keys

SSH Keys may be managed using the "sshkeys" attribute of `accounts::user`. This
attribute is expected to be an array and each value of the array is expected to
be a single string which may be a copy and paste of the public key file
contents.

Example:

~~~puppet
accounts::user { 'jeff':
  comment => 'Jeff McCune',
  groups  => [
    'admin',
    'sudonopw',
  ],
  uid     => '1112',
  gid     => '1112',
  sshkeys => [
    'ssh-rsa AAAAB3Nza...== jeff@puppetlabs.com',
    'ssh-dss AAAAB3Nza...== jeff@metamachine.net',
  ],
}
~~~


##Reference

### Class: accounts
Base class to configure how the accounts::users resources behave, and accept hashes from hiera.
#### groups_hash
Accepts a hash of group resources, ie from hiera. Required if `manage_groups` is true. Defaults to undef

#### manage_groups
Whether or not this module manages a set of default shared groups. These groups
must be defined in the `groups_hash` parameter. Accepts true/false, default true.

#### manage_users
Whether or not this module manages a set of default shared users. These users
must be defined in the `users_hash` parameter. Configuration values that apply
to all users should be in the `users_hash_default` variable. Accepts true/false,
default true.

#### manage_sudoers
Whether or not this module should add sudo rules to the sudoers file of the
client with file_line. If specified as true, it will add groups %sudo and
%sudonopw and give them full sudo and full passwordless sudo privileges
respectively. Defaults to false.

#### sudoers_path
Location of sudoers file on client systems. Defaults to /etc/sudoers

#### users_hash
Accepts a hash of account::user resources, ie from hiera. Required if `manage_users` is true. Defaults to undef

### Define: accounts::user
This resource manages the user, group, .vim/, .ssh/, .bash_profile, .bashrc, homedir, .ssh/authorized\_keys files and directories. Currently the content of the dotfiles is not customizable, but this feature will be added in the future.

#### comment
Manage the user comment. Default to `$name`
#### ensure
Manage the ensure property of the user, group, homedir, and ssh keys. Default 'present'
#### gid
Manage the gid of the user's group. Default undef
#### groups
Manage the users group membership. Must be an array. Default empty array.
#### home
Manage the users homedir path. Default '/home/$name'
#### locked
Manage whether the account is locked. Accepts true/false. Default false.
#### managehome
Pass managehome to the user resource. Will also purge the users homedir if ensure is absent and managehome is true. Default true.
#### membership
Configure the user resource `groups` scope. Default 'minimum'
#### password
Manage the user password hash. Default '!!'
#### shell
Manage the user shell. Default '/bin/bash'
#### sshkeys
Manage the users ssh keys. Must be an array. Default empty array.
#### uid
Manage the users uid. Default undef.


##Limitations

This module works with Puppet Enterprise 2015.3 and later.

## Development

This module was built by Puppet Labs specifically for use with Puppet Enterprise (PE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you are having problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).
