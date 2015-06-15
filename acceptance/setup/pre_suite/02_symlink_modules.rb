
require 'lib/puppet_acceptance/dsl/install_utils'

extend PuppetAcceptance::DSL::InstallUtils

step "Linking accounts module in to modulepath"

module_path = '/opt/puppet/share/puppet/modules'

# preserve the PE installed accounts module (it'll get restored after the test run is complete)
on master, "test -d #{SourcePath}/accounts && mv #{module_path}/accounts #{module_path}/accounts.original"

on master, "ln -s #{SourcePath}/accounts #{module_path}"
