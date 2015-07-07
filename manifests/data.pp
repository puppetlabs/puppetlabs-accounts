# Class: accounts::data
#
#   This is the default set of data provided to with the accounts module.
#   Customers should define their own data class and configure the accounts
#   module using the class param $data_namespace variable
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
  # The groups_hash defines "shared" supplementary groups.
  $groups_hash = { }

  # These are the actual accounts on the system to manage
  $users_hash = { }
}
