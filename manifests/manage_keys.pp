#
define accounts::manage_keys(
  $keyspec,
  $user,
  $key_file,
) {

  $key_def = $keyspec.match(/^((.*)\s+)?((ssh|ecdsa-sha2).*)\s+(.*)\s+(.*)$/)
  if (! $key_def) {
    err("Could not interpret SSH key definition: '${keyspec}'")
  }
  else {
    if ($key_def[2]) {
      $key_options = accounts_ssh_options_parser($key_def[2])
    } else {
      $key_options = undef
    }
    $key_type    = $key_def[3]
    $key_content = $key_def[5]
    $key_name    = $key_def[6]

    $key_title = "${user}_${key_type}_${key_name}"

    ssh_authorized_key { $key_title:
      ensure  => present,
      user    => $user,
      key     => $key_content,
      type    => $key_type,
      options => $key_options,
      target  => $key_file,
    }
  }
}
