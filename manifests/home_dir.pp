# @summary
#   This resource specifies how home directories are managed.
#
# @param group
#   Name of the user's primary group.
#
# @param user 
#   Name of the user that owns all of the files being created.
#
# @param managevim
#   Specifies whether or not the .vim folder should be created within the managed account's home directory.
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
# @param forward_content
#   The content to place in the user's ~/.forward file. Mutually exclusive to forward_source. 
#
# @param forward_source
#   A source file containing the content to place in the user's ~/.forward file. Mutually exclusive to forward_content. 
#
# @param mode
#   Manages the user's home directory permission mode. Valid values are in octal notation.
#
# @param ensure
#   Specifies whether the user, its primary group, homedir, and ssh keys should exist. Valid values are 'present' and 'absent'. Note that 
#   when a user is created, a group with the same name as the user is also created. 
#
# @param name 
#   Path of the home directory that is being managed.
#
# @api private
#
define accounts::home_dir(
  String $user,
  String $group,
  Boolean $managevim                     = true,
  Optional[String] $bashrc_content       = undef,
  Optional[String] $bashrc_source        = undef,
  Optional[String] $bash_profile_content = undef,
  Optional[String] $bash_profile_source  = undef,
  Optional[String] $forward_content      = undef,
  Optional[String] $forward_source       = undef,
  Optional[String] $mode                 = undef,
  Pattern[/^(present|absent)$/] $ensure  = 'present',
) {

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

    if $managevim {
      file { "${name}/.vim":
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0700',
      }
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
