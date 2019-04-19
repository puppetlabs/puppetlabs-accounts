# @summary
#   This resource manages the user, group, vim/, .ssh/, .bash_profile, .bashrc,
#   homedir, .ssh/authorized_keys files, and directories.
#
# @example Basic usage
#   accounts::user { 'bob':
#     uid      => '4001',
#     gid      => '4001',
#     group    => 'staff',
#     shell    => '/bin/bash',
#     password => '!!',
#     locked   => false,
#   }
#
# @param ensure
#   Specifies whether the user, its primary group, homedir, and ssh keys should
#   exist. Valid values are 'present' and 'absent'. Note that when a user is
#   created, a group with the same name as the user is also created.
#
# @param allowdupe
#   Whether to allow duplicate UIDs. By default false
#
# @param bash_profile_content
#   The content to place in the user's ~/.bash_profile file. Mutually exclusive
#   to bash_profile_source.
#
# @param bash_profile_source
#   A source file containing the content to place in the user's ~/.bash_profile
#   file. Mutually exclusive to bash_profile_content.
#
# @param bashrc_content
#   The content to place in the user's ~/.bashrc file. Mutually exclusive to
#   bashrc_source.
#
# @param bashrc_source
#   A source file containing the content to place in the user's ~/.bashrc file.
#   Mutually exclusive to bashrc_content.
#
# @param comment
#   A comment describing or regarding the user.
#
# @param create_group
#   Specifies if you want to create a group with the user's name.
#
# @param expiry
#   Specifies the date the user account expires on. Valid values: YYYY-MM-DD
#   date format, or 'absent' to remove expiry date.
#
# @param forcelocal
#   Specifies whether you want to manage a local user/group that is also managed
#   by a network name service.
#
# @param forward_content
#   The content to place in the user's ~/.forward file. Mutually exclusive to
#   forward_source.
#
# @param forward_source
#   A source file containing the content to place in the user's ~/.forward file.
#   Mutually exclusive to forward_content.
#
# @param gid
#   Specifies the gid of the user's primary group. Must be specified
#   numerically.
#
# @param group
#   Specifies the name of the user's primary group. By default, this uses a
#   group named the same as user name
#
# @param groups
#   Specifies the user's group memberships.
#
# @param home
#   Specifies the path to the user's home directory.
#
#   - Linux, non-root user: '/home/$name'
#
#   - Linux, root user: '/root'
#
#   - Solaris, non-root user: '/export/home/$name'
#
#   - Solaris, root user: '/'
#
# @param home_mode
#   Manages the user's home directory permission mode. Valid values are in octal
#   notation, specified as a string. Defaults to undef, which creates a home
#   directory with 0700 permissions. It does not touch them if the directory
#   already exists. Keeping it undef also allows a user to manage their own
#   permissions. If home_mode is set, Puppet enforces the permissions on every
#   run.
#
# @param ignore_password_if_empty
#   Specifies whether an empty password field should be ignored. If set to true,
#   this ignores a password field that is defined but empty. If set to false, it
#   sets the password to an empty value.
#
# @param iterations
#   This is the number of iterations of a chained computation of the PBKDF2
#   password hash. This field is required for managing passwords on OS X >=
#   10.8.
#
# @param locked
#   Specifies whether the account should be locked and the user prevented from
#   logging in. Set to true for users whose login privileges have been revoked.
#
# @param managehome
#   Specifies whether the user's home directory should be managed by puppet. In
#   addition to the usual user resource managehome qualities, this attribute
#   also purges the user's homedir if ensure is set to 'absent' and managehome
#   is set to true.
#
# @param managevim
#   Specifies whether or not the .vim folder should be created within the
#   managed accounts home directory.
#
# @param membership
#   Establishes whether specified groups should be considered the complete list
#   (inclusive) or the minimum list (minimum) of groups to which the user
#   belongs. Valid values: 'inclusive', 'minimum'.
#
# @param name
#   Name of the user.
#
# @param password
#   The user's password, in whatever encrypted format the local machine
#   requires. Default: '!!', which prevents the user from logging in with a
#   password.
#
# @param purge_sshkeys
#   Whether keys not included in sshkeys should be removed from the user. If
#   purge_sshkeys is true and sshkeys is an empty array, all SSH keys will be
#   removed from the user.
#
# @param purge_user_home
#   Whether to force recurse remove user home directories when removing a user.
#   Defaults to false.
#
# @param salt
#   This is the 32-byte salt used to generate the PBKDF2 password used in OS X.
#   This field is required for managing passwords on OS X >= 10.8.
#
# @param shell
#   Manages the user shell.
#
# @param sshkey_custom_path
#   Custom location for ssh public key file.
#
# @param sshkey_owner
#   Specifies the owner of the sshkey file .ssh/authorized_keys.
#
# @param sshkeys
#   An array of SSH public keys associated with the user. These should be
#   complete public key strings that include the type, content and name of the
#   key, exactly as it would appear in its id_*.pub file, or with an optional
#   options string preceding the other components, as it would appear as an
#   entry in an authorized_keys file. Must be an array.
#
#   Examples:
#
#   - ssh-rsa AAAAB3NzaC1y... bob@example.com
#
#   - from="myhost.example.com,192.168.1.1" ssh-rsa AAAAQ4ng... bob2@example.com
#
#   Note that for multiple keys, the name component (the last) must be unique.
#
# @param system
#   Specifies if you want to create a system account.
#
# @param uid
#   Specifies the user's uid number. Must be specified numerically.
#
define accounts::user (
  Enum['absent','present']             $ensure                   = 'present',
  Boolean                              $allowdupe                = false,
  Optional[String]                     $bash_profile_content     = undef,
  Optional[Stdlib::Filesource]         $bash_profile_source      = undef,
  Optional[String]                     $bashrc_content           = undef,
  Optional[Stdlib::Filesource]         $bashrc_source            = undef,
  String                               $comment                  = $name,
  Boolean                              $create_group             = true,
  Optional[Accounts::User::Expiry]     $expiry                   = undef,
  Optional[Boolean]                    $forcelocal               = undef,
  Optional[String]                     $forward_content          = undef,
  Optional[Stdlib::Filesource]         $forward_source           = undef,
  Optional[Accounts::User::Uid]        $gid                      = undef,
  Accounts::User::Name                 $group                    = $name,
  Array[Accounts::User::Name]          $groups                   = [],
  Optional[Stdlib::Unixpath]           $home                     = undef,
  Optional[Stdlib::Filemode]           $home_mode                = undef,
  Boolean                              $ignore_password_if_empty = false,
  Optional[Accounts::User::Iterations] $iterations               = undef,
  Boolean                              $locked                   = false,
  Boolean                              $managehome               = true,
  Boolean                              $managevim                = true,
  Enum['inclusive','minimum']          $membership               = 'minimum',
  String                               $password                 = '!!',
  Boolean                              $purge_sshkeys            = false,
  Boolean                              $purge_user_home          = false,
  Optional[String]                     $salt                     = undef,
  Optional[Stdlib::Unixpath]           $shell                    = '/bin/bash',
  Optional[Stdlib::Unixpath]           $sshkey_custom_path       = undef,
  Optional[Accounts::User::Name]       $sshkey_owner             = $name,
  Array[String]                        $sshkeys                  = [],
  Boolean                              $system                   = false,
  Optional[Accounts::User::Uid]        $uid                      = undef,
) {

  assert_type(Accounts::User::Name, $name)
  if $home {
    $_home = $home
  } elsif $name == 'root' {
    $_home = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $_home = $::osfamily ? {
      'Solaris' => "/export/home/${name}",
      default   => "/home/${name}",
    }
  }

  if $locked {
    case $::operatingsystem {
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
        ensure     => $ensure,
        gid        => $gid,
        system     => $system,
        forcelocal => $forcelocal,
      }
    # Only remove the group if it is the same as user name as it may be shared
    } elsif $ensure == 'absent' and $name == $group {
      group { $group:
        ensure     => $ensure,
        forcelocal => $forcelocal,
      }
    }
  }

  if $purge_sshkeys {
    if $sshkey_custom_path != undef {
      $purge_sshkeys_value = ["${sshkey_custom_path}"] # lint:ignore:only_variable_string
    }
    else { $purge_sshkeys_value = true }
  }
  else { $purge_sshkeys_value = false }


  if  $password == '' and $ignore_password_if_empty {
    user { $name:
      ensure         => $ensure,
      shell          => $_shell,
      comment        => "${comment}", # lint:ignore:only_variable_string
      home           => $_home,
      uid            => $uid,
      gid            => $group,
      allowdupe      => $allowdupe,
      groups         => $groups,
      membership     => $membership,
      managehome     => $managehome,
      purge_ssh_keys => $purge_sshkeys_value,
      system         => $system,
      forcelocal     => $forcelocal,
      expiry         => $expiry,
    }
  } else {
    user { $name:
      ensure         => $ensure,
      shell          => $_shell,
      comment        => "${comment}", # lint:ignore:only_variable_string
      home           => $_home,
      uid            => $uid,
      gid            => $group,
      allowdupe      => $allowdupe,
      groups         => $groups,
      membership     => $membership,
      managehome     => $managehome,
      password       => $password,
      salt           => $salt,
      iterations     => $iterations,
      purge_ssh_keys => $purge_sshkeys_value,
      system         => $system,
      forcelocal     => $forcelocal,
      expiry         => $expiry,
    }
  }

  if $create_group {
    if $ensure == 'present' {
      Group[$group] -> User[$name]
    } else {
      User[$name] -> Group[$group]
    }
  }

  if $managehome {
    accounts::home_dir { $_home:
      ensure               => $ensure,
      mode                 => $home_mode,
      managevim            => $managevim,
      bashrc_content       => $bashrc_content,
      bashrc_source        => $bashrc_source,
      bash_profile_content => $bash_profile_content,
      bash_profile_source  => $bash_profile_source,
      forward_content      => $forward_content,
      forward_source       => $forward_source,
      user                 => $name,
      group                => $group,
      require              => [ User[$name] ],
    }
    accounts::key_management { "${name}_key_management":
      ensure             => $ensure,
      user               => $name,
      group              => $group,
      user_home          => $_home,
      sshkeys            => $sshkeys,
      sshkey_custom_path => $sshkey_custom_path,
      purge_user_home    => $purge_user_home,
      require            => Accounts::Home_dir[$_home]
    }
  } elsif $sshkeys != [] {
    # We are not managing the user's home directory but we have specified a
    # custom, non-home directory for the ssh keys.
      if (($sshkey_custom_path != undef) and ($ensure == 'present')) {
        accounts::key_management { "${name}_key_management":
          ensure             => $ensure,
          user               => $sshkey_owner,
          group              => $group,
          sshkeys            => $sshkeys,
          sshkey_owner       => $sshkey_owner,
          sshkey_custom_path => $sshkey_custom_path,
        }
      }
      else {
        warning(translate('ssh keys were passed for user %{name} but $managehome is set to false; not managing user ssh keys',
        {'name' => $name}))
      }
  }
}
