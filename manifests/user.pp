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
  $ensure                   = 'present',
  $shell                    = '/bin/bash',
  $comment                  = $name,
  $home                     = undef,
  $home_mode                = undef,
  $uid                      = undef,
  $gid                      = undef,
  $group                    = $name,
  $groups                   = [ ],
  $create_group             = true,
  $membership               = 'minimum',
  $forcelocal               = undef,
  $password                 = '!!',
  $locked                   = false,
  $sshkeys                  = [],
  $purge_sshkeys            = false,
  $managehome               = true,
  $bashrc_content           = undef,
  $bashrc_source            = undef,
  $bash_profile_content     = undef,
  $bash_profile_source      = undef,
  $system                   = false,
  $ignore_password_if_empty = false,
  $forward_content          = undef,
  $forward_source           = undef,
  $expiry                   = undef,
  Optional[String] $sshkey_custom_path = undef,
) {
  validate_legacy(String, 'validate_re', $ensure, '^present$|^absent$')
  validate_legacy(Boolean, 'validate_bool', $locked, $managehome, $purge_sshkeys, $ignore_password_if_empty)
  validate_legacy(String, 'validate_re', $shell, '^/')
  validate_legacy(String, 'validate_string', $comment, $password, $group)
  validate_legacy(Tuple, 'validate_array', $groups, $sshkeys)
  validate_legacy(String, 'validate_re', $membership, '^inclusive$|^minimum$')
  if $bashrc_content {
    validate_legacy(String, 'validate_string', $bashrc_content)
  }
  if $bashrc_source {
    validate_legacy(String, 'validate_string', $bashrc_source)
  }
  if $bash_profile_content {
    validate_legacy(String, 'validate_string', $bash_profile_content)
  }
  if $bash_profile_source {
    validate_legacy(String, 'validate_string', $bash_profile_source)
  }
  if $forward_content {
    validate_legacy(String, 'validate_string', $forward_content)
  }
  if $forward_source {
    validate_legacy(String, 'validate_string', $forward_source)
  }
  if $expiry {
    unless $expiry == 'absent' {
      validate_re($expiry,'^\d{4}-\d{2}-\d{2}$')
    }
  }

  if $home {
    validate_legacy(String, 'validate_re', $home, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_legacy(String, 'validate_re', $home, '^/$|[^/]$')
  }

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

  if $uid != undef {
    validate_legacy(String, 'validate_re', $uid, '^\d+$')
  }

  if $gid != undef {
    validate_legacy(String, 'validate_re', $gid, '^\d+$')
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
      home           => $home_real,
      uid            => $uid,
      gid            => $group,
      groups         => $groups,
      membership     => $membership,
      managehome     => $managehome,
      password       => $password,
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
