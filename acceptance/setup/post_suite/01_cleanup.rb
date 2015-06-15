
step "Cleaning up modulepath symlink"

module_path = '/opt/puppet/share/puppet/modules'

on master, "readlink #{module_path}/accounts && rm #{module_path}/accounts"
on master, "test -d #{module_path}/accounts.original && mv #{module_path}/accounts.original #{module_path}/accounts"
