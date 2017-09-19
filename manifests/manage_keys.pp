#
define accounts::manage_keys(
  $user,
  $key_file,
) {

  $key_array   = split($name, ' ')
  # If the key array doesn't start with ssh or ecdsa, then key_array[0] is
  # assumed to contain ssh options separated by commas.
  if $key_array[0] =~ /^ssh|^ecdsa-sha2/ {
    $key_options = undef
    $key_type    = $key_array[0]
    $key_content = $key_array[1]
    $key_name    = $key_array[2]
  } else {
    $key_options = accounts_ssh_options_parser($key_array[0])
    $key_type    = $key_array[1]
    $key_content = $key_array[2]
    $key_name    = $key_array[3]
  }
  $key_title = "${user}_${key_type}_${key_name}"

  ssh_authorized_key { $key_title:
    ensure  => present,
    user    => $user,
    name    => $key_name,
    key     => $key_content,
    type    => $key_type,
    options => $key_options,
    target  => $key_file,
  }
}
