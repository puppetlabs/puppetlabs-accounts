# @summary
#   This resource manages ssh keys for a user.
#
# @param key_file
#   Specifies the path of the ssh key file.
#
# @param keyspec
#   Specifies the content of the ssh key file.
#
# @param user
#   Specifies the ssh login username.
#
# @param ensure
#   Specifies whether the keys will be added ('present') or removed ('absent').
#
# @param key_owner
#   Specifies the owner of the ssh key file.
#
# @api private
#
define accounts::manage_keys(
  Stdlib::Unixpath         $key_file,
  Hash                     $keyspec,
  Accounts::User::Name     $user,
  Enum['absent','present'] $ensure    = 'present',
  Accounts::User::Name     $key_owner = $user,
)
{
  case $keyspec['keytype'] {
    /^((?:ecdsa-sha2|ssh)-\w)$/: { $key_def = $1 }
    default: { err(translate("Could not interpret SSH keytype definition: '%{keyspec}'", {'keyspec' => $keyspec['keytype']})) }
  }

  if 'options' in $keyspec {
    $key_options = accounts_ssh_options($keyspec['options'])
  }
  else {
    $key_options = undef
  }

  $key_name    = $keyspec['keyid'] ? {
    undef   => undef,
    default => $keyspec['keyid']
  }
  $key_type    = $keyspec['keytype']
  $key_content = join(split($keyspec['keystring'], " "), "")
  $key_title   = "${user}_${key_type}_${key_name}"

  if $ensure == 'absent' {
    Ssh_authorized_key[$key_title] -> User[$user]
  }

  ssh_authorized_key { $key_title:
    ensure  => $ensure,
    user    => $key_owner,
    key     => $key_content,
    type    => $key_type,
    options => $key_options,
    target  => $key_file,
  }
}
