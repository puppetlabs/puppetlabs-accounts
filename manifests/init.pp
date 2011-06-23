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
#  This class will automatically be included for you.  The class should not
#  be a parameterized class.
#
#  [*manage_groups*] Whether or not this module manages a set of default shared
#  groups.  These groups must be defined in the $groups_hash hash in the
#  _data_namespace_
#
#  [*manage_users*] Whether or not this module manages a set of default shared
#  users.  These users must be defined in the $users_hash in the
#  _data_namespace_

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
    validate_hash($groups_hash)

    class { 'accounts::groups':
      groups_hash => $groups_hash,
    }

    Anchor['accounts::begin'] -> Class['accounts::groups']
    Class['accounts::groups'] -> Anchor['accounts::end']

  }

  if $manage_users_real {
    # This section of the code is repsonsible for pulling in the data we need.
    $users_hash = getvar("${data_namespace_real}::users_hash")
    validate_hash($users_hash)
    # The default hash will be merged into the users hash.
    $users_hash_default = getvar("${data_namespace_real}::users_hash_default")
    validate_hash($users_hash_default)

    # Disabled until Ruby DSL classes support parameters.
    # class { 'accounts::users':
    #   users_hash => $users_hash,
    # }

    # FIXME We're relying on $users_hash being in scope
    # when this class is declared.
    class { 'accounts::users': }

    # FIXME See #8050, Puppet does not allow a before metaparameter and -> to be used at the same time.
    # class { 'accounts::users':
    #   before => Anchor['accounts::end'],
    # }

    Class['accounts::users']  -> Anchor['accounts::end']
    Anchor['accounts::begin'] -> Class['accounts::users']

    if $manage_groups_real {
      Class['accounts::groups'] -> Class['accounts::users']
    }

  }

}
