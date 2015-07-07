#
#
# parameters:
# [*name*] Name of user
# [*locked*] Whether the user account should be locked.
# [*sshkeys*] List of ssh public keys to be associated with the
# user.
# [*managehome*] Whether the home directory should be removed with accounts
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
  $sshkeys    = [],
  $managehome = true,
) {
  validate_re($ensure, '^present$|^absent$')
  validate_bool($locked, $managehome)
  validate_re($shell, '^/')
  validate_string($comment, $password)
  validate_re($home, '^/')
  # If the home directory is not / (root on solaris) then disallow trailing slashes.
  validate_re($home, '^/$|[^/]$')
  validate_array($groups, $sshkeys)
  validate_re($membership, '^inclusive$|^minimum$')

  if $uid != undef {
    validate_re($uid, '^\d+$')
  }

  if $gid != undef {
    validate_re($gid, '^\d+$')
    $_gid = $gid
  } else {
    $_gid = $name
  }

  if $locked {
    case $::operatingsystem {
      'debian', 'ubuntu' : {
        $_shell = '/usr/sbin/nologin'
      }
      'solaris' : {
        $_shell = '/usr/bin/false'
      }
      default : {
        $_shell = '/sbin/nologin'
      }
    }
  } else {
    $_shell = $shell
  }

  user { $name:
    ensure     => $ensure,
    shell      => $_shell,
    comment    => $comment,
    home       => $home,
    uid        => $uid,
    gid        => $_gid,
    groups     => $groups,
    membership => $membership,
    password   => $password,
  }

  # use $gid instead of $_gid since `gid` in group can only take a number
  group { $name:
    ensure => $ensure,
    gid    => $gid,
  }

  if $ensure == 'present' {
    Group[$name] -> User[$name]
  } else {
    User[$name] -> Group[$name]
  }

  accounts::home_dir { $home:
    ensure     => $ensure,
    managehome => $managehome,
    user       => $name,
    sshkeys    => $sshkeys,
    require    => [ User[$name], Group[$name] ],
  }

}
