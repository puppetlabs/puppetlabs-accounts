#
define accounts::manage_keys(
  $user,
  $sshkey,
  $key_file,
) {

  $key_array   = split($sshkey, ' ')
  $key_type    = $key_array[0]
  $key_content = $key_array[1]
  $key_name    = $key_array[2]
  $key_title = "${user}_${key_type}_${key_name}"

  ssh_authorized_key { $key_title:
    ensure => present,
    user   => $user,
    key    => $key_content,
    type   => $key_type,
    target => $key_file,
  }
}
