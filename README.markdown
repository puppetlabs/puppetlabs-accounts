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
for Puppet Enterprise. This module replaces Puppet Enterprise's built-in pe_accounts module, which was removed from PE 2015.3 and later.

This module allows you to specify users and groups using a simple Hash data structure. This Hash may be defined in a Puppet module of your choice (e.g., `site::accounts`) or in a simple YAML file on disk.

This module is designed to work on all PE-supported Unix operating systems.
Unless otherwise stated, this module does not support configuring accounts on
Microsoft Windows platforms. Do not declare `accounts::user` resources in a configuration catalog for a Windows node.

## Setup

### What accounts affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module is going to affect their MySQL instances.

If there's more they should know about, though, this is the place to mention:

* Files, packages, services, or operations that the module will alter, impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, another module, etc.), mention it here. 
	
If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional "Upgrading" section here.

### Install the accounts module

This module should be placed in your module search path. The module is
designed to be automatically updated with Puppet Enterprise updates and should
not be modified. Customization of the module behavior is intended to be done
in a namespace outside of the accounts module or using a YAML data file
outside of the module directory structure.

### Quick Start

With the module installed, simply declare the accounts class in a Puppet
managed node's catalog:

    # site.pp
    node default {
      accounts::user { 'dan': }
      accounts::user { 'jeff': }
    }

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

    --- 
      villain:
        comment: Bad Person
        locked: true

The accounts module will set the account to an invalid shell appropriate for
the system Puppet is managing.

    $ ssh villain@centos56
    This account is currently not available.
    Connection to 172.16.214.129 closed.

### Manage SSH keys

SSH Keys may be managed using the "sshkeys" attribute of each user in the
Account data. This attribute is expected to be an array and each value of the
array is expected to be a single string which may be a copy and paste of the
public key file contents.

For example, on Mac OS X:

    $ pbcopy < ~/.ssh/id_dsa.pub

Once copied, you can add the key to your account by setting the sshkeys
attribute in the `accounts_users_hash.yaml` date file:

    # /etc/puppet/data/accounts_users_hash.yaml
    ---
      jeff:
        comment: Jeff McCune
        groups:
        - admin
        - sudonopw
        uid: '1112'
        gid: '1112'
        sshkeys:
        - ssh-rsa AAAAB3Nza...== jeff@puppetlabs.com
        - ssh-dss AAAAB3Nza...== jeff@metamachine.net
      dan:
        comment: Dan Bode
        uid: '1109'
        gid: '1109'
      nigel:
        comment: Nigel Kersten
        uid: '2001'
        gid: '2001'


##Reference

List module's classes, types, providers, defines, facts, etc, along with the parameters for each.

##Limitations

This module works with Puppet Enterprise 2015.3 and later.

## Development

This module was built by Puppet Labs specifically for use with Puppet Enterprise (PE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you are having problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).

### RSpec Testing

Please see the testing README file at: `spec/README_TESTING.markdown`
