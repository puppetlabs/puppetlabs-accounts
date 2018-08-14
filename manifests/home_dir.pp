#
# Specified how home directories are managed.
#
# [*name*] Name of the home directory that is being managed.
# [*group*] Name of the users primary group
# [*user*] User that owns all of the files being created.
# [*sshkeys*] List of ssh keys to be added for this user in this
# directory
define accounts::home_dir(
  $user,
  $group,
  $bashrc_content       = undef,
  $bashrc_source        = undef,
  $bash_profile_content = undef,
  $bash_profile_source  = undef,
  $forward_content      = undef,
  $forward_source       = undef,
  $mode                 = undef,
  $ensure               = 'present',
) {
  validate_legacy(String, 'validate_re', $ensure, '^(present|absent)$')

  if $ensure == 'absent' {
    file { $name:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  } elsif $ensure == 'present' {
    # Solaris homedirs are managed in zfs by `useradd -m`. If the directory
    # does not yet exist then we can't predict how it should be created, but we
    # should still manage the user/group/mode
    file { $name:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => $mode,
    }

    file { "${name}/.vim":
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0700',
    }

    if $bashrc_content or $bashrc_source {
      file { "${name}/.bashrc":
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0644',
      }
      if $bashrc_content {
        File["${name}/.bashrc"] {
          content => $bashrc_content,
        }
      }
      if $bashrc_source {
        File["${name}/.bashrc"] {
          source => $bashrc_source,
        }
      }
    }
    if $bash_profile_content or $bash_profile_source {
      file { "${name}/.bash_profile":
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0644',
      }
      if $bash_profile_content {
        File["${name}/.bash_profile"] {
          content => $bash_profile_content,
        }
      }
      if $bash_profile_source {
        File["${name}/.bash_profile"] {
          source => $bash_profile_source,
        }
      }
    }

    if $forward_content or $forward_source {
      file { "${name}/.forward":
        ensure => file,
        owner  => $user,
        group  => $group,
        mode   => '0644',
      }
      if $forward_content {
        File["${name}/.forward"] {
          content => $forward_content,
        }
      }
      if $forward_source {
        File["${name}/.forward"] {
          source => $forward_source,
        }
      }
    }
  }
}
