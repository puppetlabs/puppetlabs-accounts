#
#
# parameters:
# [*name*] Name of user
# [*group*] Name of user's primary group (defaults to user name)
# [*locked*] Whether the user account should be locked.
# [*sshkeys*] List of ssh public keys to be associated with the
# user.
# [*managehome*] Whether the home directory should be removed with accounts
# [*system*] Whether the account should be a member of the system accounts
#
define accounts::user(
  Pattern[/^present$|^absent$/] $ensure         = 'present',
  Pattern[/^\//] $shell                         = '/bin/bash',
  String $comment                               = $name,
  Optional[Pattern[/^\/$|^\/.*[^\/]$/]] $home   = undef,
  Optional[String] $home_mode                   = undef,
  Optional[Pattern[/^\d+$/]] $uid               = undef,
  Optional[Pattern[/^\d+$/]] $gid               = undef,
  String $group                                 = $name,
  Array[String] $groups                         = [ ],
  Boolean $create_group                         = true,
  Pattern[/^inclusive$|^minimum$/] $membership  = 'minimum',
  Optional[Boolean] $forcelocal                 = undef,
  String $password                              = '!!',
  Optional[String] $salt                        = undef,
  Optional[Integer] $iterations                 = undef,
  Boolean $locked                               = false,
  Array[String] $sshkeys                        = [],
  Boolean $purge_sshkeys                        = false,
  Boolean $managehome                           = true,
  Optional[String] $bashrc_content              = undef,
  Optional[String] $bashrc_source               = undef,
  Optional[String] $bash_profile_content        = undef,
  Optional[String] $bash_profile_source         = undef,
  Boolean $system                               = false,
  Boolean $ignore_password_if_empty             = false,
  Optional[String] $forward_content             = undef,
  Optional[String] $forward_source              = undef,
  Optional[Pattern[/^absent$|^\d{4}-\d{2}-\d{2}$/]] $expiry = undef,
  Optional[String] $sshkey_custom_path          = undef,
) {

  if $home {
    $home_real = $home
  } elsif $name == 'root' {
    $home_real = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $home_real = $::osfamily ? {
      'Solaris' => "/export/home/${name}",
      default   => "/home/${name}",
    }
  }

  $managehome_real = $::osfamily ? {
    'Darwin' => false,
    default  => $managehome,
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
      home           => $home_real,
      uid            => $uid,
      gid            => $group,
      groups         => $groups,
      membership     => $membership,
      managehome     => $managehome_real,
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
      home           => $home_real,
      uid            => $uid,
      gid            => $group,
      groups         => $groups,
      membership     => $membership,
      managehome     => $managehome_real,
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
    accounts::home_dir { $home_real:
      ensure               => $ensure,
      mode                 => $home_mode,
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
      user               => $name,
      group              => $group,
      user_home          => $home_real,
      sshkeys            => $sshkeys,
      sshkey_custom_path => $sshkey_custom_path,
      require            => Accounts::Home_dir[$home_real]
    }
  } elsif $sshkeys != [] {
    # We are not managing the user's home directory but we have specified a
    # custom, non-home directory for the ssh keys.
      if $sshkey_custom_path != undef {
        accounts::key_management { "${name}_key_management":
          user               => $name,
          group              => $group,
          user_home          => $home_real,
          sshkeys            => $sshkeys,
          sshkey_custom_path => $sshkey_custom_path,
        }
      }
      else {
        warning("ssh keys were passed for user ${name} but \$managehome is set to false; not managing user ssh keys")
      }
  }
}
