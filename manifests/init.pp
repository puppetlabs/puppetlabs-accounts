# Class: accounts
#
#   This module manages accounts on a Puppet managed system.
#
#   The goal of this module is to provide effective user and group management
#   without having to modify any Puppet Code.
#
# Parameters:
#
#  [*manage_groups*] Whether or not this module manages a set of default shared
#  groups.  These groups must be defined in the $groups_hash parameter
#
#  [*manage_users*] Whether or not this module manages a set of default shared
#  users. These users must be defined in the $users_hash parameter.
#  Configuration values that apply to all users should be in the
#  $users_hash_default variable.
#
#  [*manage_sudoers*] Whether or not this module should add sudo rules to the sudoers
#  file of the client. If specified as true, it will add groups %sudo and %sudonopw
#  and give them full sudo and full passwordless sudo privileges respectively.
#  Defaults to false.
#
#  [*sudoers_path*] Location of sudoers file on client systems.
#  defaults to /etc/sudoers
#
# Actions:
#
# Requires:
#
#   Puppet Labs 'stdlib' Module more recent than 0.0.4
#   http://forge.puppetlabs.com/puppetlabs/stdlib
#
# Sample Usage:
#
#   node default {
#     notify { 'alpha': }
#     ->
#     class  { 'accounts':
#       data_store => 'yaml',
#     }
#     ->
#     notify { 'omega': }
#   }
#
class accounts (
  $manage_groups   = true,
  $manage_users    = true,
  $manage_sudoers  = false,
  $sudoers_path    = '/etc/sudoers'
  # Deprecated
  $data_store      = undef,
  $data_namespace  = undef,
) {

  # Must be fully qualified
  validate_re($sudoers_path, '^/[^/]+')
  # Must not have a trailing slash
  validate_re($sudoers_path, '[^/]$')
  validate_bool($manage_sudoers)
  validate_bool($manage_groups)
  validate_bool($manage_users)

  # Deprecated
  if $data_store or $data_namespace {
    warning("accounts data has been deprecated. Use hiera instead.")
  }
  if $data_store {
    $_data_store = $data_store
  } else {
    $_data_store = 'namespace'
  }
  if $data_namespace {
    $_data_namespace = $data_namespace
  } else {
    $_data_namespace = 'accounts::data'
  }
  validate_re($_data_store, '^namespace$|^yaml$')
  validate_re($_data_namespace, '::data$')
  case $_data_store {
    namespace: {
      include $_data_namespace
      $groups_hash = getvar("${_data_namespace}::groups_hash")
      $users_hash = getvar("${_data_namespace}::users_hash")
      validate_hash($users_hash, $groups_hash)
    }

    yaml: {
      $datadir = inline_template('<%= File.join(Puppet[:confdir], "data") %>')
      $users_hash_file = inline_template("<%= File.join('${datadir}', 'accounts_users_hash.yaml')%>")
      $users_hash = loadyaml($users_hash_file)
      $groups_hash_file = inline_template("<%= File.join('${datadir}', 'accounts_groups_hash.yaml')%>")
      $groups_hash = loadyaml($groups_hash_file)
      validate_hash($users_hash, $groups_hash)
    }

    default: {}
  }

  anchor { 'accounts::begin': }
  anchor { 'accounts::end': }

  if $manage_groups {

    class { 'accounts::groups':
      groups_hash => $groups_hash,
    }

    Anchor['accounts::begin'] -> Class['accounts::groups'] -> Anchor['accounts::end']

  }

  if $manage_users {
    create_resources('accounts::user', $users_hash)
  }

  if $manage_sudoers {
    case $::operatingsystem {
      solaris: {
        warning("manage_sudoers is ${manage_sudoers} but is not supported on ${::operatingsystem}")
      }
      default: {
        file_line { 'sudo_rules':
          path => $sudoers_path,
          line => '%sudo ALL=(ALL) ALL',
        }
        file_line { 'sudonopw_rules':
          path => $sudoers_path,
          line => '%sudonopw ALL=NOPASSWD: ALL'
        }
      }
    }
  }

}
