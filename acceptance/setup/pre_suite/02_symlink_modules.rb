
require 'lib/puppet_acceptance/dsl/install_utils'

extend PuppetAcceptance::DSL::InstallUtils

step "Linking pe_accounts module in to modulepath"

module_path = '/opt/puppet/share/puppet/modules'

# preserve the PE installed accounts module (it'll get restored after the test run is complete)
on master, "test -d #{SourcePath}/pe_accounts && mv #{module_path}/pe_accounts #{module_path}/pe_accounts.original"

on master, "ln -s #{SourcePath}/pe_accounts #{module_path}"