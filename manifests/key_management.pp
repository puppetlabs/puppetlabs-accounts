#
# Specify where ssh keys are managed
#
# [*group*] Name of the users primary group
# [*user*] User that owns all of the files being created.
# [*sshkeys*] List of ssh keys to be added for this user in this
# directory
# [*sshkey_custom_path*] Path for custom file for ssh key management
#
define accounts::key_management(
  $user,
  $group,
  $user_home,
  $sshkeys            = [],
  $sshkey_custom_path = undef,
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
