#
#
# parameters:
# [*name*] Name of user
# [*group*] Name of user's primary group (defaults to user name)
# [*locked*] Whether the user account should be locked.
# [*sshkeys*] List of ssh public keys to be associated with the
# user.
# [*managehome*] Whether the home directory should be removed with accounts
# [*system*] Whether the account should be a member of the system accounts
#
# @param ensure Ensure present or absent
# @param shell Users's shell
# @param comment Gecos comment
# @param home Home directory location
# @param home_mode Permissions mode for home directory
# @param uid UID of the user
# @param gid GID for the user
# @param groups Secondary groups for the user
# @param membership Minimum or inclusive membership for groups
# @param password  Encrypted password for this account
# @param locked Should this account be locked
# @param sshkeys Array of SSH keys to put in the authorized keys file
# @param purge_sshkeys Should SSH keys not managed be purged
# @param managehome Should Puppet manage the home directory
# @param bashrc_content Content for the bashrc file
# @param bashrc_source  Source file for the bashrc file
# @param bash_profile_content Content for the bash_profile file
# @param bash_profile_source  Source file for the bash_profile file

define accounts::user(
  $ensure               = 'present',
  $shell                = '/bin/bash',
  $comment              = $name,
  $home                 = undef,
  $home_mode            = undef,
  $uid                  = undef,
  $gid                  = undef,
  $group                = $name,
  $groups               = [ ],
  $create_group         = true,
  $membership           = 'minimum',
  $password             = '!!',
  $locked               = false,
  $sshkeys              = [],
  $purge_sshkeys        = false,
  $managehome           = true,
  $bashrc_content       = undef,
  $bashrc_source        = undef,
  $bash_profile_content = undef,
  $bash_profile_source  = undef,
  $system               = false,
) {
  validate_re($ensure, '^present$|^absent$')
  validate_bool($locked, $managehome, $purge_sshkeys)
  validate_re($shell, '^/')
  validate_string($comment, $password, $group)
  validate_array($groups, $sshkeys)
  validate_re($membership, '^inclusive$|^minimum$')
  if $bashrc_content {
    validate_string($bashrc_content)
  }
  if $bashrc_source {
    validate_string($bashrc_source)
  }
  if $bash_profile_content {
    validate_string($bash_profile_content)
  }
  if $bash_profile_source {
    validate_string($bash_profile_source)
  }
  if $home {
    validate_re($home, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_re($home, '^/$|[^/]$')
  }

  if $home {
    $home_real = $home
  } elsif $name == 'root' {
    $home_real = $facts['osfamily']['family'] ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $home_real = $facts['osfamily']['family'] ? {
      'Solaris' => "/export/home/${name}",
      default   => "/home/${name}",
    }
  }

  if $uid != undef {
    validate_re($uid, '^\d+$')
  }

  if $gid != undef {
    validate_re($gid, '^\d+$')
  }

  if $locked {
    case $facts['os']['name'] {
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

  # Check if user wants to create the group
  if $create_group {
    # Ensure that the group hasn't already been defined
    if $ensure == 'present' and ! defined(Group[$group]) {
      group { $group:
        ensure => $ensure,
        gid    => $gid,
        system => $system,
      }
    # Only remove the group if it is the same as user name as it may be shared
    } elsif $ensure == 'absent' and $name == $group {
      group { $group:
        ensure => $ensure,
      }
    }
  }

  user { $name:
    ensure         => $ensure,
    shell          => $_shell,
    comment        => "${comment}", # lint:ignore:only_variable_string
    home           => $home_real,
    uid            => $uid,
    gid            => $group,
    groups         => $groups,
    membership     => $membership,
    managehome     => $managehome,
    password       => $password,
    purge_ssh_keys => $purge_sshkeys,
    system         => $system,
  }

  if $ensure == 'present' {
    Group[$group] -> User[$name]
  } else {
    User[$name] -> Group[$group]
  }

  accounts::home_dir { $home_real:
    ensure               => $ensure,
    mode                 => $home_mode,
    managehome           => $managehome,
    bashrc_content       => $bashrc_content,
    bashrc_source        => $bashrc_source,
    bash_profile_content => $bash_profile_content,
    bash_profile_source  => $bash_profile_source,
    user                 => $name,
    group                => $group,
    sshkeys              => $sshkeys,
    require              => [ User[$name], Group[$group] ],
  }
}

