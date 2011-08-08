# Unit Testing #

This module is tested using the following components:

 * rspec > 2.6.0
 * rspec-puppet (puppetlabs master branch) (e2ab2f2)
 * puppet 2.6.9
 * facter 1.6.0
 * stdlib module 2.0.0

# Modules #

The spec helper file will automatically add the parent directory this module is
located in to the Puppet module path.  This allows multiple modules to work
together.  For example, the accounts module requires functions and resources in
the stdlib module.  For these to automatically work, I use the following directory structure:

    mkdir ~/src/modules/
    cd ~/src/modules
    git clone git@github.com:puppetlabs/puppetlabs-stdlib.git stdlib
    git clone git@github.com:puppetlabs/puppetlabs-accounts.git accounts
    cd accounts/spec
    rspec **/*_spec.rb

# Other Notes #

I use rvm with these components installed.

There is no Rakefile or rake tasks, so testing is a simple mater of:

    cd spec/
    rspec **/*_spec.rb

You should not receive any failures.  If you do, please make sure you have the
components at the specific version checked out and in the Ruby path.

