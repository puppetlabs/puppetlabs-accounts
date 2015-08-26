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

The accounts module manages resources related to login and service accounts
for Puppet Enterprise. This module replaces Puppet Enterprise's built-in pe\_accounts module, which was removed from PE 2015.3 and later.

This module works on all PE-supported Unix operating systems. It does not currently support configuring accounts on Microsoft
Windows platforms.

## Setup

**Note:** When you install this module, it is placed in your module search path. Do not modify the module; it is designed to be automatically updated with Puppet Enterprise updates.

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

If the account being managed uses the bash shell, a simple bashrc and
bash\_profile rc file is managed by Puppet for each account. These rc
files read the following files, which are not automatically managed by Puppet, in the following order:

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
parameter accepts an array of single string values, which can be copies of the public key file contents.

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

### Class: accounts

This class accepts hashes from Hiera and configures how the accounts::users resources behave.

#### `groups_hash`

*Required* if `manage_groups` is 'true'.  Allows creation of group resources. Accepts a hash of group resources, i.e., from Hiera. Default: undef.

#### `manage_groups`

Whether this module manages a set of default shared groups. These groups
must be defined in the `groups_hash` parameter. Valid values: 'true', 'false'. Default: 'true'.

#### `manage_users`

Whether this module manages a set of default shared users. These users
must be defined in the `users_hash` parameter. Configuration values that apply
to all users should be in the `users_hash_default` variable. Valid values: 'true', 'false'. Default: 'true'.

#### `manage_sudoers`

Whether this module should add sudo rules to the sudoers file of the
client with file_line. If 'true', this adds groups `%sudo` and
`%sudonopw` and gives them full sudo and full passwordless sudo privileges,
respectively. Valid values: 'true', 'false'. Default: 'false'.

#### `sudoers_path`

The location of sudoers file on client systems. Default: `/etc/sudoers`.

#### `users_hash`

*Required* if `manage_users` is true. Allows creation of user resources. Accepts a hash of `account::user` resources, i.e., from Hiera. Required if `manage_users` is true. Defaults to undef.

### Define: accounts::user

This resource manages the user, group, .vim/, .ssh/, .bash_profile, .bashrc, homedir, .ssh/authorized\_keys files and directories.

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

#### home_mode

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

This module was built by Puppet Labs specifically for use with Puppet Enterprise (PE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).
