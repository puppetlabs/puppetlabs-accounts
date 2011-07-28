# Overview #

This module manages many of the resources related to login and service accounts
on Puppet managed systems.  Unlike other Puppet Modules, this module allows you
to specify users and groups using a simple Hash data structure.  This Hash may
be defined in a Puppet module of your choice (e.g. site::accounts) or in a
simple YAML file on disk.

# Installation #

This module should be placed in your module search path.  The module is
designed to be automatically updated with Puppet Enterprise updates and should
not be modified.  Customization of the module behavior is intended to be done
in a namespace outside of the accounts module or using a YAML data file outside
of the module directory structure.

# Quick Start #

Example YAML files are provided in the ext/data/ directory in this module.
These examples should be copied to $confdir/data, e.g. /etc/puppet/data/ or
/etc/puppetlabs/puppet/data for Puppet Enterprise.

For example:

    $ mkdir $(puppet --configprint confdir)/data
    $ cp ext/data/*.yaml $(puppet --configprint confdir)/data/

Then, simply declare the accounts class in a Puppet managed node's catalog:

    # site.pp
    node default {
      class  { accounts: data_store => yaml }
    }

The above example will load the YAML files in /etc/puppet/data/ and create
accounts, home directories, and groups based on the data provided in the files.

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

The accounts module will set the account to an invalid shell appropriate for
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

