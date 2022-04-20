# Use a variable OR with hiera_hash():
# This example uses a common group name for both users

$users_hash = {
  'jblow' => {
    'comment'  => 'Joe Blow',
    'groups'   => [wheel],
    'uid'      => '1115',
    'gid'      => '1115',
    'group'    => 'mrblow',
    'sshkeys'  => [
      'ssh-rsa AAAAB3Nza...== jblow@puppetlabs.com',
      'ssh-dss AAAAB3Nza...== jblow@googler.net',
    ],
    'password' => '!!',
  },
  'kblow' => {
    'comment'  => 'Ken Blow',
    'group'    => 'mrblow',
    'password' => '!!',
  },
}
create_resources('accounts::user', $users_hash)
