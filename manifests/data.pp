# Class: accounts::data
#
#   This is the default set of data provided to with the accounts module.
#   Customers should define their own data class and configure the accounts
#   module using the top level $param_accounts_data_namespace variable, or
#   setting the class parameter when declaring the module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# Make a copy of this class into your "site" module (Don't edit this class itself)
# and reconfigure the accounts module to use your data rather than it's own by
# specifying the namespace to lookup data in.
#
# node default {
#   class { 'accounts':
#     data_namespace => 'site::accounts::data',
#   }
# }
#
class accounts::data {
  # If the groups_hash does not specify these keys, then they will be
  # merged into the resource declaration
  # FIXME: Unimplemented
  /*$groups_hash_default {*/
  /*  'ensure' => 'present',*/
  /*}*/

  # The groups_hash defines "shared" supplementary groups.
  $groups_hash = {
    'admin'     => { gid => '3000' },
    'sudo'      => { gid => '3001' },
    'sudonopw'  => { gid => '3002' },
    'developer' => { gid => '3003' },
  }
  # These are the actual accounts on the system to manage

  # FIXME We don't have a hash merge function yet
  # FIXME We don't have any way to pass data that's not
  # directly usable by the type.
  # Idea: filter_type_hash('user', $users_hash)
  # Which would remove keys like "sshkey"
  $users_hash_default = {
    password => '!!',
    shell    => '/bin/bash',
    ensure   => 'present',
    home     => '/home/#{title}'
  }

  $users_hash = {
    'jeff' => {
      'shell'    => '/bin/zsh',
      'comment'  => 'Jeff McCune',
      'groups'   => [ admin, sudonopw, ],
      'password' => '!!',
      'uid'      => '1112',
      'gid'      => '1112',
      'sshkey'   => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzlnWpbiDfBLJWWh3xEIMo3QJhB+/TucyWtqTB3B3np1LHi7/zJW9L5KwqgCPfcCSPKY4ekW4K5DwZgXufM74+acBJqAIioJby5AVlkYtRMuJItzRYfkClN0Ex/8rCc/y8T+Wa5Q7Kyy73312xxqbeO8nzNkDO2Zx2oxxHVDSeThX5+Tk1lFj3LpsWbuTsImK9KsVPX50M6uNQxSt4ASx0SDe0MDLC5uzbGYtjqkZQYEYguo7O64t81+C3JK3BHDPsL5G5H7g2qwPJ7ola1sV1wDCGE9ago09QZvYpOacPbtbesFhbwKP31eDz2PWGSJ4DCIoLKhmfpEuDpiih649VQ== jeff@puppetlabs.com'
    },
    'dan' => {
      'comment'  => 'Dan Bode',
      'uid'      => '1109',
      'gid'      => '1109',
    },
    'nigel' => {
      'shell'    => '/bin/bash',
      'comment'  => 'Nigel Kersten',
      'uid'      => '2001',
      'gid'      => '2001',
    }
  }

}
