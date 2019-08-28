accounts::user { 'jeff':
  shell    => '/bin/zsh',
  comment  => 'Jeff McCune',
  groups   => [
    'admin',
    'sudonopw',
  ],
  uid      => '1112',
  gid      => '1112',
  locked   => true,
  sshkeys  => [{
    keyid     => 'rsa:jeff@puppetlabs.com',
    keystring => 'AAAAB3Nza...==',
    keytype   => 'ssh-rsa',
  },
  {
    keyid     => 'dss:jeff@metamachine.net',
    keystring => 'AAAAB3Nza...==',
    keytype   => 'ssh-dss',
  }],
  password => '!!',
}
accounts::user { 'dan':
  comment => 'Dan Bode',
  uid     => '1109',
  gid     => '1109',
}
