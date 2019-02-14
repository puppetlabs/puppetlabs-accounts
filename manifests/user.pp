# @summary 
#   This resource manages the user, group, vim/, .ssh/, .bash_profile, .bashrc, homedir, .ssh/authorized_keys files, and directories.
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
#   Specifies whether the user, its primary group, homedir, and ssh keys should exist. Valid values are 'present' and 'absent'. Note that 
#   when a user is created, a group with the same name as the user is also created. 
#
# @param shell 
#   Manages the user shell.
#
# @param comment 
#   A comment describing or regarding the user.
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
#   Manages the user's home directory permission mode. Valid values are in octal notation, specified as a string. Defaults to undef, 
#   which creates a home directory with 0700 permissions. It does not touch them if the directory already exists. Keeping it undef also 
#   allows a user to manage their own permissions. If home_mode is set, Puppet enforces the permissions on every run.
#
# @param uid 
#   Specifies the user's uid number. Must be specified numerically.
#
# @param gid 
#   Specifies the gid of the user's primary group. Must be specified numerically. 
#
# @param allowdupe
#   Whether to allow duplicate UIDs. By default false
#
# @param group
#   Specifies the name of the user's primary group. By default, this uses a group named the same as user name
#
# @param groups
#   Specifies the user's group memberships.
#
# @param create_group
#   Specifies if you want to create a group with the user's name. 
#
# @param membership
#   Establishes whether specified groups should be considered the complete list (inclusive) or the minimum list (minimum) of groups to 
#   which the user belongs. Valid values: 'inclusive', 'minimum'.
#   
# @param forcelocal
#   Specifies whether you want to manage a local user/group that is also managed by a network name service.
#
# @param password
#   The user's password, in whatever encrypted format the local machine requires. Default: '!!', which prevents the user from logging in 
#   with a password.
#
# @param salt
#   This is the 32-byte salt used to generate the PBKDF2 password used in OS X. This field is required for managing passwords on 
#   OS X >= 10.8.
#
# @param iterations
#   This is the number of iterations of a chained computation of the PBKDF2 password hash. This field is required for managing passwords on 
#   OS X >= 10.8.
#   
# @param locked
#   Specifies whether the account should be locked and the user prevented from logging in. Set to true for users whose login privileges 
#   have been revoked.
#
# @param sshkeys
#   An array of SSH public keys associated with the user. These should be complete public key strings that include the type, content and 
#   name of the key, exactly as it would appear in its id_*.pub file, or with an optional options string preceding the other components, 
#   as it would appear as an entry in an authorized_keys file. Must be an array. 
#
#   Examples:
#
#   - ssh-rsa AAAAB3NzaC1y... bob@example.com
#
#   - from="myhost.example.com,192.168.1.1" ssh-rsa AAAAQ4ngoeiC... bob2@example.com
#
#   Note that for multiple keys, the name component (the last) must be unique.
#
# @param purge_sshkeys
#   Whether keys not included in sshkeys should be removed from the user. If purge_sshkeys is true and sshkeys is an empty array, all SSH 
#   keys will be removed from the user.
#   
# @param managehome
#   Specifies whether the user's home directory should be managed by puppet. In addition to the usual user resource managehome qualities, 
#   this attribute also purges the user's homedir if ensure is set to 'absent' and managehome is set to true.
#
# @param managevim
#   Specifies whether or not the .vim folder should be created within the managed accounts home directory.
#
# @param bashrc_content 
#   The content to place in the user's ~/.bashrc file. Mutually exclusive to bashrc_source.
#
# @param bashrc_source
#   A source file containing the content to place in the user's ~/.bashrc file. Mutually exclusive to bashrc_content.
#
# @param bash_profile_content
#   The content to place in the user's ~/.bash_profile file. Mutually exclusive to bash_profile_source.
#
# @param bash_profile_source
#   A source file containing the content to place in the user's ~/.bash_profile file. Mutually exclusive to bash_profile_content. 
#
# @param system
#   Specifies if you want to create a system account. 
#
# @param ignore_password_if_empty
#   Specifies whether an empty password field should be ignored. If set to true, this ignores a password field that is defined but 
#   empty. If set to false, it sets the password to an empty value.
#
# @param forward_content
#   The content to place in the user's ~/.forward file. Mutually exclusive to forward_source. 
#
# @param forward_source
#   A source file containing the content to place in the user's ~/.forward file. Mutually exclusive to forward_content. 
#
# @param expiry
#   Specifies the date the user account expires on. Valid values: YYYY-MM-DD date format, or 'absent' to remove expiry date.
#
# @param sshkey_custom_path
#   Custom location for ssh public key file.
#
# @param name
#   Name of the user.
#
define accounts::user(
  Pattern[/^present$|^absent$/] $ensure                     = 'present',
  Pattern[/^\//] $shell                                     = '/bin/bash',
  String $comment                                           = $name,
  Optional[Pattern[/^\/$|^\/.*[^\/]$/]] $home               = undef,
  Optional[String] $home_mode                               = undef,
  Optional[Pattern[/^\d+$/]] $uid                           = undef,
  Optional[Pattern[/^\d+$/]] $gid                           = undef,
  Boolean $allowdupe                                        = false,
  String $group                                             = $name,
  Array[String] $groups                                     = [ ],
  Boolean $create_group                                     = true,
  Pattern[/^inclusive$|^minimum$/] $membership              = 'minimum',
  Optional[Boolean] $forcelocal                             = undef,
  String $password                                          = '!!',
  Optional[String] $salt                                    = undef,
  Optional[Integer] $iterations                             = undef,
  Boolean $locked                                           = false,
  Array[String] $sshkeys                                    = [],
  Boolean $purge_sshkeys                                    = false,
  Boolean $managehome                                       = true,
  Boolean $managevim                                        = true,
  Optional[String] $bashrc_content                          = undef,
  Optional[String] $bashrc_source                           = undef,
  Optional[String] $bash_profile_content                    = undef,
  Optional[String] $bash_profile_source                     = undef,
  Boolean $system                                           = false,
  Boolean $ignore_password_if_empty                         = false,
  Optional[String] $forward_content                         = undef,
  Optional[String] $forward_source                          = undef,
  Optional[Pattern[/^absent$|^\d{4}-\d{2}-\d{2}$/]] $expiry = undef,
  Optional[String] $sshkey_custom_path                      = undef,
) {

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
    if ( $ensure == 'present' ) {
      accounts::key_management { "${name}_key_management":
        user               => $name,
        group              => $group,
        user_home          => $_home,
        sshkeys            => $sshkeys,
        sshkey_custom_path => $sshkey_custom_path,
        require            => Accounts::Home_dir[$_home]
      }
    }
  } elsif $sshkeys != [] {
    # We are not managing the user's home directory but we have specified a
    # custom, non-home directory for the ssh keys.
      if (($sshkey_custom_path != undef) and ($ensure == 'present')) {
        accounts::key_management { "${name}_key_management":
          user               => $name,
          group              => $group,
          sshkeys            => $sshkeys,
          sshkey_custom_path => $sshkey_custom_path,
        }
      }
      else {
        warning(translate('ssh keys were passed for user %{name} but $managehome is set to false; not managing user ssh keys',
        {'name' => $name}))
      }
  }
}
