# Class: accounts
#
#   This module manages accounts on a Puppet managed system.
#
#   The goal of this module is to provide effective user and group management
#   without having to modify any Puppet Code.  Users and Groups may be configured
#   using simple data files or variables in a Puppet manifest.
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
#  _data_namespace_.  Please see the accounts::data class included in this module
#  for an example.
#
#  [*manage_users*] Whether or not this module manages a set of default shared
#  users.  These users must be defined in the $users_hash in the
#  _data_namespace_.  Configuration values that apply to all users should be
#  in the $users_hash_default variable.  Please see the accounts::data class
#  included in this module for an example.
#
#  [*manage_sudoers*] Whether or not this module should add sudo rules to the sudoers
#  file of the client. If specified as true, it will add groups %sudo and %sudonopw
#  and give them full sudo and full passwordless sudo privileges respectively.
#  Defaults to true.
#
#  [*data_store*] Where the data specifying accounts and groups live.  This
#  setting may be 'yaml' or 'namespace' (Defaults to namespace).  When set to
#  namespace the puppet class specified with the data_namespace class parameter
#  will be used.  YAML data store is the default.  Examples of these
#  configuration files are located in the ext/data/ directory of this module.
#  These files should be copied to a data directory inside Puppet's confdir.
#  For example:
#   * /etc/puppet/data/accounts_users_hash.yaml
#   * /etc/puppet/data/accounts_users_default_hash.yaml
#   * /etc/puppet/data/accounts_groups_hash.yaml
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
  $manage_sudoers  = true,
  $data_store      = 'namespace',
  $data_namespace  = 'accounts::data',
  $sudoers_path    = '/etc/sudoers'
) {

  # Must be fully qualified
  validate_re($sudoers_path, '^/[^/]+')
  # Must not have a trailing slash
  validate_re($sudoers_path, '[^/]$')
  validate_bool($manage_sudoers)
  validate_re($data_store, '^namespace$|^yaml$')
  $data_store_real = $data_store
  validate_re($data_namespace, '::data$')
  $data_namespace_real = $data_namespace
  validate_bool($manage_groups)
  $manage_groups_real = $manage_groups
  validate_bool($manage_users)
  $manage_users_real = $manage_users

  # We always populate these Hash data structures because the accounts::user defined
  # Type needs the $accounts::users_hash_default variable.
  case $data_store_real {
    namespace: {
      # Make sure the namespace is added to the catalog.
      include "${data_namespace_real}"
      $groups_hash = getvar("${data_namespace_real}::groups_hash")
      validate_hash($groups_hash)
      # This section of the code is repsonsible for pulling in the data we need.
      $users_hash = getvar("${data_namespace_real}::users_hash")
      validate_hash($users_hash)
      # The default hash will be merged into the users hash.
      $users_hash_default = getvar("${data_namespace_real}::users_hash_default")
      validate_hash($users_hash_default)
    }

    yaml: {
      # Figure out where the default puppet confdir is for the master.
      $datadir = inline_template('<%= File.join(Puppet[:confdir], "data") %>')
      # Load the hash data from YAML
      # The files the end user defines data in.
      $users_hash_file = inline_template("<%= File.join('${datadir}', 'accounts_users_hash.yaml')%>")
      $users_hash_default_file = inline_template("<%= File.join('${datadir}', 'accounts_users_default_hash.yaml')%>")
      # Load the files and validate the basic data types.
      $users_hash = loadyaml($users_hash_file)
      validate_hash($users_hash)
      $users_hash_default = loadyaml($users_hash_default_file)
      validate_hash($users_hash_default)
      # The files the end user defines data in.
      $groups_hash_file = inline_template("<%= File.join('${datadir}', 'accounts_groups_hash.yaml')%>")
      # Load the files and validate the basic data types.
      $groups_hash = loadyaml($groups_hash_file)
      validate_hash($groups_hash)
    }
  }

  anchor { "accounts::begin": }
  anchor { "accounts::end": }

  if $manage_groups_real {

    class { 'accounts::groups':
      groups_hash => $groups_hash,
    }

    Anchor['accounts::begin'] -> Class['accounts::groups']
    Class['accounts::groups'] -> Anchor['accounts::end']

  }

  if $manage_users_real {
    # FIXME We're relying on $users_hash being in scope
    # when this class is declared.
    create_resources('accounts::user', $users_hash)
  }

  if $manage_sudoers {
    case $operatingsystem {
      solaris: {
        warning("manage_sudoers is $manage_sudoers but is not supported on $operatingsystem")
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
