define accounts::group(
  $ensure               = 'present',
  $gid                  = undef,
) {
  validate_re($ensure, '^(present|absent)$')

  if $gid != undef {
    validate_re($gid, '^\d+$')
    $_gid = $gid
  } else {
    $_gid = $name
  }

  group { $name:
    ensure => $ensure,
    gid    => $_gid,
  }
}
