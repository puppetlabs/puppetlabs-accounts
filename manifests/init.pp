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
  $manage_groups  = true,
  $manage_users   = true,
  $data_namespace = 'accounts::data'
) {

  validate_re($data_namespace, '::data$')
  $data_namespace_real = $data_namespace
  validate_bool($manage_groups)
  $manage_groups_real = $manage_groups
  validate_bool($manage_users)
  $manage_users_real = $manage_users

  # Make sure to evaluate the data namespace before trying to pull
  # data from it.
  include "${data_namespace_real}"

  anchor { "accounts::begin": }
  anchor { "accounts::end": }

  # FIXME: We need to do a hash merge of the groups_hash and groups_hash_default
  # FIXME: We need to do a hash merge of the users_hash and users_hash_default

  if $manage_groups_real {
    # This section of the code is repsonsible for pulling in the data we need.
    $groups_hash = getvar("${data_namespace_real}::groups_hash")

    class { 'accounts::groups':
      groups_hash => $groups_hash,
      require     => Anchor['accounts::begin'],
      before      => Anchor['accounts::end'],
    }

  }

  if $manage_users_real {
    # This section of the code is repsonsible for pulling in the data we need.
    $users_hash = getvar("${data_namespace_real}::users_hash")

    class { 'accounts::users':
      users_hash => $users_hash,
      require     => Anchor['accounts::begin'],
      before      => Anchor['accounts::end'],
    }

    if $manage_groups_real {
      Class['accounts::groups'] -> Class['accounts::users']
    }

  }

}
