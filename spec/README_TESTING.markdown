# Unit Testing #

This module is tested using the following components:

 * rspec > 2.6.0
 * rspec-puppet >= 0.1.0
 * puppet 2.6.9
 * facter 1.6.0
 * stdlib module 2.0.0

# Modules #

The spec helper file will automatically add the parent directory this module is
located in to the Puppet module path.  This allows multiple modules to work
together.  For example, the pe\_accounts module requires functions and resources
in the stdlib module.  For these to automatically work, I use the following
directory structure:

    mkdir ~/src/modules/
    cd ~/src/modules
    git clone git@github.com:puppetlabs/puppetlabs-stdlib.git stdlib
    git clone git@github.com:puppetlabs/puppetlabs-pe_accounts.git pe_accounts
    cd pe_accounts
    rake spec

