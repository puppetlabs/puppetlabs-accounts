# Class: accounts::data
#
#   This is the default set of data provided to with the accounts
#   module.   Customers should define their own data class and configure
#   the accounts module using the top level $param_accounts_data_namespace
#   variable, or setting the class parameter when declaring the module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class accounts::data {
  $groups_hash = {
    'admin'     => { gid => '3000' },
    'sudo'      => { gid => '3001' },
    'sudo_nopw' => { gid => '3002' },
  }
}
