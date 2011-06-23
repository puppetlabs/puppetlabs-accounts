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
  $users_hash_default = { }

  $users_hash = {
    'jeff' => {
      'ensure'   => 'present',
      'home'     => '/home/jeff',
      'shell'    => '/bin/zsh',
      'comment'  => 'Jeff McCune',
      'password' => '!!',
      'uid'      => '1112',
      'gid'      => '1112',
    },
    'dan' => {
      'ensure'   => 'present',
      'home'     => '/home/dan',
      'shell'    => '/bin/bash',
      'comment'  => 'Dan Bode',
      'password' => '!!',
      'uid'      => '1109',
      'gid'      => '1109',
    },
    'nigel' => {
      'ensure'   => 'present',
      'home'     => '/home/nigel',
      'shell'    => '/bin/bash',
      'comment'  => 'Nigel Kersten',
      'password' => '!!',
      'uid'      => '2001',
      'gid'      => '2001',
    }
  }

}
