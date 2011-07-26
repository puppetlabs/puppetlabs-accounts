# Overview #

FIXME TBD

 * [#8001](https://projects.puppetlabs.com/issues/8001)

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

Once copied, I can add the key to my account by simply setting the sshkeys attribute in the `accounts_users_hash.yaml` date file:

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

