#
#
# parameters:
# [*name*] Name of user
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
  $comment    = $name,
  $home       = "/home/${name}",
  $uid        = undef,
  $gid        = undef,
  $groups     = [ ],
  $membership = 'minimum',
  $password   = '!!',
  $locked     = false,
  $sshkeys    = []
) {
  # Validate our inputs from the end user using a "best effort" strategy
  # ensure
  validate_re($ensure, '^present$|^absent$')
  # locked
  validate_bool($locked)
  # shell (with munging _real pattern)
  validate_re($shell, '^/')
  if $locked {
    case $::operatingsystem {
      'debian', 'ubuntu' : {
        $shell_real = '/usr/sbin/nologin'
      }
      'solaris' : {
        $shell_real = '/usr/bin/false'
      }
      default : {
        $shell_real = '/sbin/nologin'
      }
    }
  } else {
    $shell_real = $shell
  }

  # comment
  if $comment != undef {
    validate_string($comment)
  }
  # home
  validate_re($home, '^/')
  # If the home directory is not / (root on solaris) then disallow trailing slashes.
  validate_re($home, '^/$|[^/]$')
  # uid number
  if $uid != undef {
    validate_re($uid, '^\d+$')
  }
  # gid number
  if $gid != undef {
    validate_re($gid, '^\d+$')
  }
  # groups
  validate_array($groups)
  # membership
  validate_re($membership, '^inclusive$|^minimum$')
  # password
  if $password != undef {
    validate_string($password)
  }
  # sshkeys
  validate_array($sshkeys)

  # The black magic with $gid is to take into account the fact that we're
  # also passing $gid to the gid property of the group resource.  Unlike
  # the user resources, the gid property of group cannot take a name, only a
  # number.
  user { $name:
    ensure     => $ensure,
    shell      => $shell_real,
    comment    => $comment,
    home       => $home,
    uid        => $uid,
    gid        => $gid ? { undef => $name, default => $gid },
    groups     => $groups,
    membership => $membership,
    password   => $password,
  }

  # create the primary group
  # what if gid is not a number?
  group { $name:
    ensure => $ensure,
    gid    => $gid,
    before => "User[${name}]",
  }

  # Manage the home directory
  accounts::home_dir { $home:
    user    => $name,
    sshkeys => $sshkeys,
    require => [ User[$name], Group[$name] ],
  }

}
