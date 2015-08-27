# accounts

#### Table of Contents
1. [Description](#description)
2. [Setup - The basics of getting started with accounts](#setup)
    * [Beginning with accounts](#beginning-with-accounts)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Description

The accounts module manages resources related to login and service accounts. This module replaces Puppet Enterprise's built-in pe\_accounts module, which was removed from PE 2015.3 and later.

This module works on many UNIX/Linux operating systems. It does not support configuring accounts on Microsoft
Windows platforms.

## Setup

### Beginning with accounts

Declare the `accounts` class in a Puppet-managed node's manifest:

~~~puppet
node default {
  accounts::user { 'dan': }
  accounts::user { 'morgan': }
}
~~~

The above example creates accounts, home directories, and groups for Dan
and Morgan.

## Usage

### Declare user accounts

~~~puppet
accounts::user { 'bob':
    uid      => 4001,
    gid      => 4001,
    shell    => '/bin/bash',
    password => '!!',
    sshkeys  => "ssh-rsa AAAA...",
    locked   => false,
  }
~~~

### Customize the home directory

A simple bashrc and
bash\_profile rc file is managed by Puppet for each account. These rc
files add some simple aliases, update the prompt, add ~/bin to the path, and source the following files (which are not managed by this module) in the following order:

 1. `/etc/bashrc`
 2. `/etc/bashrc.puppet`
 3. `~/.bashrc.custom`

Account holders can customize their shells by managing their bashrc.custom files. In addition, the system administrator can make profile changes that affect all accounts with a bash shell by managing the `/etc/bashrc.puppet` file.

### Lock accounts

Lock accounts by setting the `locked` parameter of an account to 'true'.

For example:

~~~puppet
accounts::user { 'villain':
  comment => 'Bad Person',
  locked  => true
}
~~~

The accounts module sets the account to an invalid shell appropriate for
the system Puppet is managing and displays the following message if a user tries to access the account:

~~~
$ ssh villain@centos56
This account is currently not available.
Connection to 172.16.214.129 closed.
~~~

### Manage SSH keys

Manage SSH keys managed with the `sshkeys` attribute of the `accounts::user` define. This
parameter accepts an array of public key contents as strings.

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

## Reference

### Define: accounts::user

This resource manages the user, group, .vim/, .ssh/, .bash\_profile, .bashrc, homedir, .ssh/authorized\_keys files and directories.

#### `comment`

Manage the user comment. Default to `$name`.

#### `ensure`

Manage the ensure property of the user, group, homedir, and ssh keys. Default 'present'.

#### `gid`

Manage the gid of the user's group. Default undef.

#### `groups`

Manage the users group membership. Must be an array. Default empty array.

#### `home`

Manages the user's homedir path. Default: '/home/$name'.

#### `home_mode`

Manage the users homedir mode. Default '0700'

#### `locked`

Manages whether the account is locked. Accepts true/false. Default: false.

#### `managehome`

Passes `managehome` to the user resource. Purges the user's homedir if `ensure` is absent and `managehome` is true. Default: true.

#### `membership`

Configures the user resource `groups` scope. Default: 'minimum'.

#### `password`

Manages the user password hash. Default: '!!'.

#### `shell`

Manages the user shell. Default: '/bin/bash'.

#### `sshkeys`

Manages the users ssh keys. Must be an array. Default: an empty array.

#### `uid`

Manages the users uid. Default: undef.

##Limitations

This module works with Puppet Enterprise 2015.3 and later.

## Development

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).
