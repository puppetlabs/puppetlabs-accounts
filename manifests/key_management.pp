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
  String $user_home,
  Array[String] $sshkeys = [],
  Optional[String] $sshkey_custom_path = undef,
) {

  file { "${user_home}/.ssh":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  if $sshkey_custom_path != undef {
    $key_file = $sshkey_custom_path
  }
  else {
    $key_file = "${user_home}/.ssh/authorized_keys"
  }

  file { $key_file:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0600',
  }

  if $sshkeys != [] {
    $sshkeys.each |$sshkey| {
      accounts::manage_keys { "${sshkey} for ${user}":
        keyspec  => $sshkey,
        user     => $user,
        key_file => $key_file,
        require  => [
          File["${user_home}/.ssh"],
          File[$key_file],
        ],
      }
    }
  }

}
