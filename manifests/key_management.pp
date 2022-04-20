# @summary
#   This resource specifies where ssh keys are managed.
#
# @param user
#   User that owns all of the files being created.
#
# @param ensure
#   Specifies whether the key will be added ('present') or removed ('absent').
#
# @param group
#   Name of the user's primary group.
#
# @param purge_user_home
#   Whether to force recurse remove user home directories when removing a user.
#
# @param sshkey_custom_path
#   Path to custom file for ssh key management.
#
# @param sshkey_group
#   Specifies the group of the ssh key file.
#
# @param sshkey_owner
#   Specifies the owner of the ssh key file.
#
# @param sshkey_mode
#   Specifies the mode of the ssh key file.
#
# @param sshkeys
#   List of ssh keys to be added for this user in this directory.
#
# @param user_home
#   Specifies the path to the user's home directory.
#
# @api private
#
define accounts::key_management (
  Accounts::User::Name           $user,
  Enum['absent','present']       $ensure             = 'present',
  Optional[Accounts::User::Name] $group              = undef,
  Boolean                        $purge_user_home    = false,
  Optional[Stdlib::Unixpath]     $sshkey_custom_path = undef,
  Accounts::User::Name           $sshkey_group       = $group,
  Accounts::User::Name           $sshkey_owner       = $user,
  Variant[Integer[0],String]     $sshkey_mode        = '0600',
  Array[String]                  $sshkeys            = [],
  Optional[Stdlib::Unixpath]     $user_home          = undef,
) {
  if $user_home {
    $sshkey_dotdir = "${user_home}/.ssh"
  }

  if $sshkey_custom_path != undef {
    $key_file = $sshkey_custom_path.sprintf($user)
  } elsif $user_home {
    $key_file = "${sshkey_dotdir}/authorized_keys"
  } else {
    err('Either user_home or sshkey_custom_path must be specified')
  }

  if $ensure == 'present' {
    file { $key_file:
      ensure => 'file',
      owner  => $sshkey_owner,
      group  => $sshkey_group,
      mode   => $sshkey_mode,
    }
    if $user_home {
      file { $sshkey_dotdir:
        ensure => 'directory',
        owner  => $user,
        group  => $group,
        mode   => '0700',
      }
    }
    if $sshkey_custom_path != undef {
      $sshkey_require = File[$key_file]
    } else {
      $sshkey_require = File[$sshkey_dotdir]
    }
    $sshkey_before = undef
  } else {
    if $purge_user_home and $user_home {
      file { $sshkey_dotdir:
        ensure  => 'absent',
        before  => User[$user],
        recurse => true,
        force   => true,
      }
      $sshkey_before = [File[$key_file], File[$sshkey_dotdir]]
    } else {
      $sshkey_before = File[$key_file]
    }
    file { $key_file:
      ensure => 'absent',
      before => User[$user],
    }
    $sshkey_require = undef
  }

  if $sshkeys != [] {
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
