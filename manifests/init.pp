# Class: accounts
#
#   This module manages accounts on a Puppet managed system.
#
#   FIXME: Add more information here
#
# Parameters:
#
#  [*data_namespace*] The Puppet namespace to find data.  Override the default
#  of 'accounts::data' with your own namespace.  The string must end with
#  ::data.  site::accounts::data is a good choice.
#
#  [*manage_groups*] Whether or not this module manages a set of default shared
#  groups.  These groups must be defined in the $groups hash in the
#  _data_namespace_
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class accounts (
  $data_namespace = 'accounts::data',
  $manage_groups  = true
) {

  validate_re($data_namespace, '::data$')
  $data_namespace_real = $data_namespace
  validate_bool($manage_groups)
  $manage_groups_real = $manage_groups

  # This section of the code is repsonsible for pulling in the data we need.
  $groups_hash = lookupvar("${data_namespace_real}::groups_hash")

  debug("ACCOUNTS: groups_pash = $groups_hash")

  anchor { "accounts::begin": }
  anchor { "accounts::end": }

  if $manage_groups_real {
    class { 'accounts::groups': }
  }


}
