
step "Cleaning up modulepath symlink"

module_path = '/opt/puppet/share/puppet/modules'

on master, "readlink #{module_path}/pe_accounts && rm #{module_path}/pe_accounts"
on master, "test -d #{module_path}/pe_accounts.original && mv #{module_path}/pe_accounts.original #{module_path}/pe_accounts"