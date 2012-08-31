
test_name 'Removing a pe_accounts managed user with managehome disabled should not remove the users home directory'

step 'Creating account'

apply_manifest_on(master, "pe_accounts::user {'arthur':
  ensure => present
}")

step 'Removing account keeping their home directory intact'

apply_manifest_on(master, "pe_accounts::user {'arthur':
  ensure => absent,
  managehome => false
}")

on master, 'test -d /home/arthur'

# this seems kind of redundant?
on master, 'test -d /home/arthur && rm -rf /home/arthur'