# accounts

#### Table of Contents
1. [Description](#description)
2. [Setup - The basics of getting started with accounts](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
	* [Declare user accounts](#declare-user-accounts)
	* [Customize the home directory](#customize-the-home-directory)
	* [Lock accounts](#lock-accounts)
	* [Manage SSH keys](#manage-ssh-keys)
	* [Data in hiera](#data-in-hiera)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
        * [Data Types](#data-types)
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
  sshkey_group       => 'root',
  sshkey_owner       => 'root',
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

<a id="data-in-hiera"></a>
### Data in Hiera

The accounts module supports storing all account data in Hiera.

Example:

~~~yaml
accounts::group_defaults:
  system: true
accounts::group_list:
  admins: {}
  users:  {}
accounts::user_defaults:
  groups: [ 'users' ]
  managehome: true
  system:     false
accounts::user_list:
  admin:
    groups: ['admins', 'users']
  joe:
    sshkeys:
      - &joe_sshkey 'ssh-rsa ... joe@corp.com'
  sally:
    sshkeys:
      - &sally_sshkey 'ssh-rsa ... sally@corp.com'
  dba:
    sshkeys:
      - *joe_sshkey
      - *sally_sshkey
    system: true
~~~

~~~puppet
include ::accounts
~~~

## Reference

See [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-accounts/blob/main/REFERENCE.md)

<a id="data-types"></a>
### Data types

#### `Accounts::Group::Hash`

A hash of [`group`](https://puppet.com/docs/puppet/latesttypes/group.html#group) data suitable for passing as the second parameter to [`ensure_resources`](https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resources).

#### `Accounts::Group::Provider`

The allowed values for the [`provider`](https://puppet.com/docs/puppet/latest/types/group.html#group-attribute-provider) attribute.  Currently, this is:
* `aix`
* `directoryservice`
* `groupadd`
* `ldap`
* `pw`
* `windows_adsi`

#### `Accounts::Group::Resource`

A struct of [`group` attributes](https://puppet.com/docs/puppet/latest/types/group.html#group-attributes) suitable for passing as the third parameter to [`ensure_resource`](https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resource).

#### `Accounts::User::Expiry`

Allows either `'absent'` or a `YYY-MM-DD` datestring.

#### `Accounts::User::Hash`

A hash of [`user`](https://puppet.com/docs/puppet/latest/types/user.html#user) data suitable for passing as the second parameter to [`ensure_resources`](https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resources).

#### `Accounts::User::Iterations`

The [`iterations`](https://puppet.com/docs/puppet/latest/types/user.html#user-attribute-iterations) attribute allows any positive integer, optionally expressed as a string.

#### `Accounts::User::Name`

Allows strings up to 32 characters long that begin with a lower case letter or underscore, followed by lower case letters, digits, underscores, or dashes, and optionally ending in a dollar sign.  See [`useradd(8)`](http://manpages.ubuntu.com/manpages/precise/man8/useradd.8.html#caveats)

#### `Accounts::User::PasswordMaxAge`

Maximum number of days a password may be used before it must be changed. Allows any integer from `0` to `99999`. See [`user`](https://puppet.com/docs/puppet/latest/types/user.html#user-attribute-password_max_age) resource.

#### `Accounts::User::Resource`

A struct of [`user` attributes](https://puppet.com/docs/puppet/latest/types/user.html#user-attributes) suitable for passing as the third parameter to [`ensure_resource`](https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resource).

#### `Accounts::User::Uid`

Allows any integer from `0` to `4294967295` (2<sup>32</sup> - 1), optionally expressed as a string.

## Limitations

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-accounts/blob/main/metadata.json)

### Changes from pe\_accounts

The accounts module is designed to take the place of the pe\_accounts module that shipped with PE versions 2015.2 and earlier. Some of the changes include the removal of the base class, improving the validation, and allowing more flexibility regarding which files should or should not be managed in a user's home directory.

For example, the .bashrc and .bash\_profile files are not managed by default but allow custom content to be passed in using the `bashrc_content` and `bash_profile_content` parameters. The content for these two files as managed by pe\_accounts can continue to be used by passing `bashrc_content => file('accounts/shell/bashrc')` and `bash_profile_content => file('accounts/shell/bash_profile')` to the `accounts::user` defined type.

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
To run the acceptance tests follow the instructions [here](https://github.com/puppetlabs/puppet_litmus/wiki/Tutorial:-use-Litmus-to-execute-acceptance-tests-with-a-sample-module-(MoTD)#install-the-necessary-gems-for-the-module).
You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).
Every Monday the Puppet IA Content Team has [office hours](https://puppet.com/community/office-hours) in the [Puppet Community Slack](http://slack.puppet.com/), alternating between an EMEA friendly time (1300 UTC) and an Americas friendly time (0900 Pacific, 1700 UTC).

If you have problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).

If you submit a change to this module, be sure to regenerate the reference documentation as follows:

```bash
puppet strings generate --format markdown --out REFERENCE.md
```
