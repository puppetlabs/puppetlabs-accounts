#
# Specified how home directories are managed.
#
# [*name*] Name of the home directory that is being managed.
# [*user*] User that owns all of the files being created.
# [*sshkeys*] List of ssh keys to be added for this user in this
# directory
define accounts::home_dir(
  $user,
  $ensure     = 'present',
  $managehome = true,
  $sshkeys    = [],
) {
  validate_re($ensure, '^(present|absent)$')

  if $ensure == 'absent' and $managehome == true {
    file { $name:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  } elsif $ensure == 'present' {

    $key_file = "${name}/.ssh/authorized_keys"

    file { $name:
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0700',
    }

    file { "${name}/.ssh":
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0700',
    }

    file { "${name}/.vim":
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0700',
    }

    file { "${name}/.bashrc":
      source  => 'puppet:///modules/accounts/shell/bashrc',
      owner   => $user,
      group   => $user,
      mode    => '0644',
      replace => false,
    }
    file { "${name}/.bash_profile":
      source  => 'puppet:///modules/accounts/shell/bash_profile',
      owner   => $user,
      group   => $user,
      mode    => '0644',
      replace => false,
    }

    file { $key_file:
      ensure => file,
      owner  => $user,
      group  => $user,
      mode   => '0600',
    }

    if $sshkeys != [] {
      accounts::manage_keys { $sshkeys:
        user     => $user,
        key_file => $key_file,
        require  => File["${name}/.ssh"],
        before   => File[$key_file],
      }
    }
  }
}
