
test_name 'A users SSH keys should be managed'

step 'Creating account with SSH keys'

key1 = 'ssh-rsa X1TqP6p3OuouAk5QSPUlDRV91oEHw== sysop+moduledevkey@puppetlabs.com'
key2 = 'ssh-rsa ASD12asd2dhuAk5QSPUf32f23V911== sysop+moduledevkey2@puppetlabs.com'

apply_manifest_on(master, "pe_accounts::user {'arthur':
  ensure => present,
  sshkeys => ['#{key1}',
              '#{key2}'],
}")

on master, "grep '#{key1}' /home/arthur/.ssh/authorized_keys"
on master, "grep '#{key2}' /home/arthur/.ssh/authorized_keys"