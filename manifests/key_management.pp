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
# @param sshkey_custom_path 
#   Path to custom file for ssh key management.
#
# @api private
#
define accounts::key_management(
  String $user,
  String $group,
  Optional[String] $user_home = undef,
  Array[String] $sshkeys = [],
  Optional[String] $sshkey_custom_path = undef,
) {

  if $user_home {
    file { "${user_home}/.ssh":
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0700',
    }
  }

  if $sshkey_custom_path {
    $key_file = $sshkey_custom_path
  } elsif $user_home {
    $key_file = "${user_home}/.ssh/authorized_keys"
  } else {
    err(translate('Either user_home or sshkey_custom_path must be specified'))
  }

  file { $key_file:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0600',
  }

  if $sshkeys != [] {
    if $user_home {
      $requires = [File["${user_home}/.ssh"], File[$key_file]]
    } else {
      $requires = [File[$key_file]]
    }
    $sshkeys.each |$sshkey| {
      accounts::manage_keys { "${sshkey} for ${user}":
        keyspec  => $sshkey,
        user     => $user,
        key_file => $key_file,
        require  => $requires,
      }
    }
  }

}
