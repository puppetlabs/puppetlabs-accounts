# Overview #

This module manages many of the resources related to login and service accounts
on Puppet managed systems.  Unlike other Puppet Modules, this module allows you
to specify users and groups using a simple Hash data structure.  This Hash may
be defined in a Puppet module of your choice (e.g. site::pe\_accounts) or in a
simple YAML file on disk.

This module is designed to work on all PE supported Unix operating systems.
Unless otherwise stated, this module is not expected to configure accounts on
Microsoft Windows platforms.  Therefore, please avoid declaring
`pe_accounts::user` resources in a configuration catalog for a Windows node.

# Installation #

This module should be placed in your module search path.  The module is
designed to be automatically updated with Puppet Enterprise updates and should
not be modified.  Customization of the module behavior is intended to be done
in a namespace outside of the pe\_accounts module or using a YAML data file
outside of the module directory structure.

# Quick Start #

With the module installed, simply declare the pe\_accounts class in a Puppet
managed node's catalog:

    # site.pp
    node default {
      pe\_accounts::user { 'dan': }
      pe\_accounts::user { 'jeff': }
    }

The above example will create accounts, home directories, and groups for Jeff
and Dan.

# Declaring User Accounts #

The pe\_accounts::user defined resource type supports most of the major features
the user native type supports (see $ puppet describe user) and the additional
parameters of locked and sshkeys.

Examples of declaring resources are provided in the examples/ sub directory of
this module.

# Home Directory Customization #

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

# Locking Accounts #

Accounts managed with this module may be easily locked by setting the "locked"
property of an account to true.

For example:

    --- 
      villain:
        comment: Bad Person
        locked: true

The pe\_accounts module will set the account to an invalid shell appropriate for
the system Puppet is managing.

    $ ssh villain@centos56
    This account is currently not available.
    Connection to 172.16.214.129 closed.

# SSH Key Management #

SSH Keys may be managed using the "sshkeys" attribute of each user in the
Account data.  This attribute is expected to be an array and each value of the
array is expected to be a single string which may be a copy and paste of the
public key file contents.

For example, on Mac OS X:

    $ pbcopy < ~/.ssh/id_dsa.pub

Once copied, I can add the key to my account by simply setting the sshkeys
attribute in the `pe_accounts_users_hash.yaml` date file:

    # /etc/puppet/data/pe_accounts_users_hash.yaml
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

# RSpec Testing #

Please see the testing README file at: `spec/README_TESTING.markdown`

