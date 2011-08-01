#
#
# parameters:
# [*name*] Name of user
# [*user_params*] Parameters that will be passed to the
# created user resource.
# [*locked*] Whether the user account should be locked.
# [*sshkeys*] List of ssh public keys to be associated with the
# user.
# [*data_namespace*] Namespace where users_hash_default variable will be
# looked-up. Defaults to accounts::data. The class that represents this
# namespace will be included into the accounts::user define.
#
define accounts::user(
  $user_params = {},
  $locked = false,
  $sshkeys = [],
  $data_namespace = 'accounts::data'
) {

  # import configurable user defaults
  include $data_namespace
  $users_hash_default = getvar("${data_namespace}::users_hash_default")
  validate_hash($users_hash_default)

  # if the account should be locked, create a hash to be
  # merged over the user_params hash.
  if $locked {
    case $::operatingsystem {
      'debian', 'ubuntu' : {
        $locked_shell = '/usr/sbin/nologin'
      }
      'solaris' : {
        $locked_shell = '/usr/bin/false'
      }
      default : {
        $locked_shell = '/sbin/nologin'
      }
    }
    $shell_param = {'shell' => $locked_shell}
  } else {
    $shell_param = {}
  }

  # if a home directory was not provided, assume a reasonable
  # default
  if has_key($user_params, 'home') {
    $home_param = {}
  } else {
    $home_param = {'home' => "/home/${name}"}
  }

  # merge the user_params over the user defaults, then merge over the
  # shell and home hashes that we just created.
  $user_params_real = merge($users_hash_default, $user_params, $shell_param, $home_param)

  # create our user
  $user_hash = {"${name}" => $user_params_real}
  create_resources('user', $user_hash)

  # create the primary group
  # what if gid is not a number?
  if has_key($user_params, 'gid') {
    group { $name:
      gid    => $user_params_real['gid'],
      ensure => $user_params_real['ensure'],
      before => "User[${name}]",
    }
  }
  # manage home directory if specified
  if has_key($user_params_real, 'home') {
    accounts::home_dir { $user_params_real['home']:
      user     => $name,
      ssh_keys => $sshkeys,
    }
  } else {
    if $sshkeys != [] {
      fail("Cannot specify sshkeys without a home directory")
    }
  }

}
