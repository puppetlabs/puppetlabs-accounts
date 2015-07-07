#
# Specified how home directories are managed.
#
# [*name*] Name of the home directory that is being managed.
# [*user*] User that owns all of the files being created.
# [*sshkeys*] List of ssh keys to be added for this user in this
# directory
define accounts::home_dir(
  $user,
  $sshkeys = [],
) {

  # manage ssh public keys if they were specified
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

  # Basic customization (#8582)
  # Bash configuration
  file { "${name}/.bashrc":
    source => "puppet:///modules/accounts/shell/bashrc",
    owner  => $user,
    group  => $user,
    mode   => '0644',
  }
  file { "${name}/.bash_profile":
    source => "puppet:///modules/accounts/shell/bash_profile",
    owner  => $user,
    group  => $user,
    mode   => '0644',
  }

  # Manage the file permissions of the authorized_keys file
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
      before   => File["${key_file}"],
    }
  }

}
