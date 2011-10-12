#
# Specified how home directories are managed.
#
# [*name*] Name of the home directory that is being managed.
# [*user*] User that owns all of the files being created.
# [*sshkeys*] List of ssh keys to be added for this user in this
# directory
define pe_accounts::home_dir(
  $user,
  $sshkeys = []
) {

  # manage ssh public keys if they were specified
  $key_file = "${name}/.ssh/authorized_keys"

  File { owner => $user, group => $user, mode => '0644' }

  file { [$name, "${name}/.ssh", "${name}/.vim"]:
    ensure => directory,
    mode => '0700',
  }

  # Basic customization (#8582)
  # Bash configuration
  file { "${name}/.bashrc":
    source  => "puppet:///modules/pe_accounts/shell/bashrc",
  }
  file { "${name}/.bash_profile":
    source  => "puppet:///modules/pe_accounts/shell/bash_profile",
  }

  # Manage the file permissions of the authorized_keys file
  file { $key_file:
   ensure => file,
   mode   => '0600',
  }

  if $sshkeys != [] {
    pe_accounts::manage_keys { $sshkeys:
      user     => $user,
      key_file => $key_file,
      require  => File["${name}/.ssh"],
      before   => File["${key_file}"],
    }
  }

}
