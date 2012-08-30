
test_name 'Adding and removing pe_accounts managed users'

step 'Creating account'

apply_manifest_catching_failures(master, "pe_accounts::user {'arthur':
  ensure => present
}", { :catch_failures => true })

master.user_get('arthur')
master.group_get('arthur')

# ensure that the users home directory was populated
on master, 'test -d /home/arthur'
on master, 'test -d /home/arthur/.ssh/'
on master, 'test -d /home/arthur/.vim/'
on master, 'test -f /home/arthur/.bashrc'
on master, 'test -f /home/arthur/.bash_profile'
on master, 'test -f /home/arthur/.ssh/authorized_keys'

step 'Removing account'

apply_manifest_catching_failures(master, "pe_accounts::user {'arthur':
  ensure => absent
}", { :catch_failures => true })

on master, 'test ! -d /home/arthur'