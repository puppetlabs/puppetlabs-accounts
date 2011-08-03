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
# looked-up. Defaults to accounts, which itself imports data into it's
# namespace from the location you specify.  NOTE: this class should be
# declared in the catalog before accounts::user resources are declared.
#
define accounts::user(
  $ensure     = 'present',
  $shell      = '/bin/bash',
  $comment    = 'UNSET',
  $home       = 'UNSET',
  $uid        = 'UNSET',
  $gid        = 'UNSET',
  $groups     = [ ],
  $membership = 'minimum',
  $password   = '!!',
  $locked     = false,
  $sshkeys    = []
) {
  # Validate our inputs from the end user using a "best effort" strategy
  # ensure
  validate_re($ensure, '^present$|^absent$')
  $ensure_real = $ensure
  # shell
  validate_re($shell, '^/')
  $shell_real = $shell
  # comment
  if "$comment" == 'UNSET' {
    $comment_real = $name
  } else {
    # we need validate_string() here
    # But, we allow the end user to specify comment => undef.
    $comment_real = $comment
  }
  # home
  if "$home" == 'UNSET' {
    $home_real = "/home/${name}"
  } else {
    validate_re($home, '^/')
    $home_real = $home
  }
  # uid number
  if "$uid" == 'UNSET' {
    $uid_real = undef
  } else {
    validate_re($uid, '^\d+$')
    $uid_real = $uid
  }
  # gid number
  if "$gid" == 'UNSET' {
    $gid_real = undef
  } else {
    validate_re($gid, '^\d+$')
    $gid_real = $gid
  }
  # groups
  # FIXME: Validate we've been given an Array
  $groups_real = $groups
  # membership
  validate_re($membership, '^inclusive$|^minimum$')
  $membership_real = $membership
  # password
  # FIXME: Not sure how to validate this input...  It could be most anything?
  $password_real = $password
  # locked
  validate_bool($locked)
  $locked_real = $locked
  # sshkeys
  # FIXME: Not sure how to valiate this input...  Array of keys?
  $sshkeys_real = $sshkeys

  # Build the Hash to feed to create_resources()
  $user_params = {
    ensure     => $ensure_real,
    shell      => $shell_real,
    comment    => $comment_real,
    home       => $home_real,
    uid        => $uid_real,
    gid        => $gid_real ? { undef => $name, default => $gid_real },
    groups     => $groups_real,
    membership => $membership_real,
    password   => $password_real,
  }

  # if the account should be locked, create a hash to be
  # merged over the user_params hash.
  if $locked_real {
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

  # Replace the shell attribute with the locked shell if
  # the hash declared above is not empty.
  $user_params_real = merge($user_params, $shell_param)

  # create our user
  $user_hash = {"${name}" => $user_params_real}
  create_resources('user', $user_hash)

  # create the primary group
  # what if gid is not a number?
  group { $name:
    ensure => $ensure_real,
    gid    => $gid_real,
    before => "User[${name}]",
  }

  # Manage the home directory
  accounts::home_dir { $user_params_real['home']:
    user     => $name,
    ssh_keys => $sshkeys,
    require  => [ User[$name], Group[$name] ],
  }

}
