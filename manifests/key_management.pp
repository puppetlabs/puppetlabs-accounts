# @summary
#   This resource specifies where ssh keys are managed.
#
# @param group
#   Name of the users primary group.
#
# @param user
#   User that owns all of the files being created.
#
# @param user_home
#   Specifies the path to the user's home directory.
#
# @param sshkeys
#   List of ssh keys to be added for this user in this directory.
#
# @param sshkey_owner
#   Specifies the owner of the ssh key file.
#
# @param sshkey_custom_path
#   Path to custom file for ssh key management.
#
# @param purge_user_home
#   Whether to force recurse remove user home directories when removing a user
#
# @api private
#
define accounts::key_management(
  String $user,
  String $group,
  Boolean $purge_user_home,
  Optional[String] $user_home = undef,
  Array[String] $sshkeys = [],
  String $sshkey_owner = $user,
  Optional[String] $sshkey_custom_path = undef,
  Enum['present','absent'] $ensure = 'present',
) {

  if $sshkey_custom_path != undef {
    $key_file = $sshkey_custom_path
  } elsif $user_home {
    $key_file = "${user_home}/.ssh/authorized_keys"
  } else {
    err(translate('Either user_home or sshkey_custom_path must be specified'))
  }

  if $ensure == 'present' {
    $dot_ssh_dir_ensure = 'directory'
    $dot_ssh_dir_recurse = undef
    $dot_ssh_dir_force = undef
    $key_file_ensure = 'file'
  } else {
    $dot_ssh_dir_ensure = 'absent'
    if $purge_user_home {
      $dot_ssh_dir_recurse = true
      $dot_ssh_dir_force = true
    } else {
      $dot_ssh_dir_recurse = undef
      $dot_ssh_dir_force = undef
    }
    $key_file_ensure = 'absent'
    File[$key_file] -> User[$user]
    if $user_home {
      File["${user_home}/.ssh"] -> File[$user_home]
    }
  }
  if $user_home {
    file { "${user_home}/.ssh":
      ensure  => $dot_ssh_dir_ensure,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      recurse => $dot_ssh_dir_recurse,
      force   => $dot_ssh_dir_force,
    }
  }

  file { $key_file:
    ensure => $key_file_ensure,
    owner  => $user,
    group  => $group,
    mode   => '0600',
  }

  if $ensure == 'present' {
    $sshkey_require = File["${user_home}/.ssh"]
    $sshkey_before = File[$key_file]
  } else {
    $sshkey_require = undef
    $sshkey_before = [File[$key_file], File["${user_home}/.ssh"]]
  }
  if $sshkeys != [] {
    if $user_home {
      $requires = [File["${user_home}/.ssh"], File[$key_file]]
    } else {
      $requires = [File[$key_file]]
    }
    $sshkeys.each |$sshkey| {
      accounts::manage_keys { "${sshkey} for ${user}":
        ensure    => $ensure,
        keyspec   => $sshkey,
        user      => $user,
        key_owner => $sshkey_owner,
        key_file  => $key_file,
        require   => $sshkey_require,
        before    => $sshkey_before,
      }
    }
  }

}
