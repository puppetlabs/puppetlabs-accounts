# accounts

#### Table of Contents
1. [Description](#description)
2. [Setup - The basics of getting started with accounts](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
	* [Declare user accounts](#declare-user-accounts)
	* [Customize the home directory](#customize-the-home-directory)
	* [Lock accounts](#lock-accounts)
	* [Manage SSH keys](#manage-ssh-keys)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Description

The accounts module manages resources related to login and service accounts.

This module works on many UNIX/Linux operating systems. It does not support configuring accounts on Microsoft Windows platforms.

## Setup

### Beginning with accounts

Declare the `accounts` class in a Puppet-managed node's manifest:

~~~puppet
node default {
  accounts::user { 'dan': }
  accounts::user { 'morgan': }
}
~~~

The above example creates accounts, home directories, and groups for Dan and Morgan.

## Usage

### Declare user accounts

~~~puppet
accounts::user { 'bob':
  uid      => '4001',
  gid      => '4001',
  group    => 'staff',
  shell    => '/bin/bash',
  password => '!!',
  locked   => false,
}
~~~

### Customize the home directory

A simple bashrc and bash\_profile rc file is managed by Puppet for each account. These rc files add some simple aliases, update the prompt, add ~/bin to the path, and source the following files (which are not managed by this module) in the following order:

 1. `/etc/bashrc`
 2. `/etc/bashrc.puppet`
 3. `~/.bashrc.custom`

Account holders can customize their shells by managing their bashrc.custom files. In addition, the system administrator can make profile changes that affect all accounts with a bash shell by managing the '/etc/bashrc.puppet' file.

To install an email foward, configure the `.forward` file by using the `forward_content` or `forward_source` parameters.

### Lock accounts

Lock accounts by setting the `locked` parameter of an account to true.

For example:

~~~puppet
accounts::user { 'villain':
  comment => 'Bad Person',
  locked  => true
}
~~~

The accounts module sets the account to an invalid shell appropriate for the system Puppet is managing and displays the following message if a user tries to access the account:

~~~
$ ssh villain@centos56
This account is currently not available.
Connection to 172.16.214.129 closed.
~~~

### Manage SSH keys

Manage SSH keys with the `sshkeys` attribute of the `accounts::user` defined type. This parameter accepts an array of public key contents as strings.

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

The module supports placing sshkeys in a custom location. If you specify a value
for the `sshkey_custom_path` attribute of the `accounts::user` defined type, the
module will place the keys in the specified file. The module will only manage
the specified file and not the full path. If you set `purge_sshkeys` to true, and
you have also set a custom path, it will only purge the ssh keys in the custom path.

Example:

~~~puppet
accounts::user { 'gerrard':
  sshkey_custom_path => '/var/lib/ssh/gerrard/authorized_keys',
  shell              => '/bin/zsh',
  comment            => 'Gerrard Geldenhuis',
  groups             => [
    'engineering',
    'automation',
  ],
  uid                => '1117',
  gid                => '1117',
  sshkeys            => [
    'ssh-rsa AAAAB9Aza...== gerrard@dirtyfruit.co.uk',
    'ssh-dss AAAAB9Aza...== gerrard@dojo.training',
  ],
  password           => '!!',
}
~~~

Setting `sshkey_custom_path` is typically associated with setting `AuthorizedKeysFile /var/lib/ssh/%u/authorized_keys` in your sshd config file.

## Reference

See [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-accounts/blob/master/REFERENCE.md)

## Limitations

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-accounts/blob/master/metadata.json)

### Changes from pe\_accounts

The accounts module is designed to take the place of the pe\_accounts module that shipped with PE versions 2015.2 and earlier. Some of the changes include the removal of the base class, improving the validation, and allowing more flexibility regarding which files should or should not be managed in a user's home directory.

For example, the .bashrc and .bash\_profile files are not managed by default but allow custom content to be passed in using the `bashrc_content` and `bash_profile_content` parameters. The content for these two files as managed by pe\_accounts can continue to be used by passing `bashrc_content => file('accounts/shell/bashrc')` and `bash_profile_content => file('accounts/shell/bash_profile')` to the `accounts::user` defined type.

## Development

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).
