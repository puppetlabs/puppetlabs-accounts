
## Getting pe_accounts acceptance tests running with pe-dev-env ##

The acceptance test suite requires a no-password root login, so we have to copy the Vagrant generated key file to root's home directory.
We also have to set up the directory that git repositories are cloned in to.

Run the following in your _master_ VM:

    cp /home/vagrant/.ssh/authorized_keys /root/.ssh/
    mkdir /opt/puppet-git-repos/

After doing that, use the following as an example for running the actual tests. The commands are run from the directory of
a clone of [puppet_acceptance](https://github.com/puppetlabs/puppet-acceptance). Note that you may have to change the IP
specified in `$MODULE_PATH/acceptance/integration.cfg` if it is not the default `pe-dev-env` IP (33.33.33.10).

    export MODULE_PATH=../modules/pe_accounts

    ./systest.rb --type pe \
    --debug \
    --no-install \
    --keyfile ~/.vagrant.d/insecure_private_key \
    --config $MODULE_PATH/acceptance/integration.cfg \
    --tests $MODULE_PATH/acceptance/tests/ \
    --setup-dir $MODULE_PATH/acceptance/setup/ \
    --helper $MODULE_PATH/acceptance/helper.rb \
    --module scp://`cd $MODULE_PATH; pwd`/

Note that these acceptance tests have not been tried as part of the larger acceptance testing infrastructure/CI,
they've only been run on a local VM. YMMV.