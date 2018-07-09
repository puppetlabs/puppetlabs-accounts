group { 'admin':
  gid => 3000,
}
group { 'sudo':
  gid => 3001,
}
group { 'sudonopw':
  gid => 3002,
}
group { 'developer':
  gid => 3003,
}
group { 'ops':
  gid => 3004,
}

file { '/var/lib/ssh/jeff':
  ensure => directory,
  owner  => 'jeff',
  group  => 'jeff',
}

accounts::user { 'jeff':
  sshkey_custom_path => '/var/lib/ssh/jeff/authorized_keys',
  shell              => '/bin/zsh',
  comment            => 'Jeff McCune',
  purge_sshkeys      => true,
  groups             => [
    'admin',
    'sudonopw',
  ],
  uid                => '1112',
  gid                => '1112',
  locked             => true,
  sshkeys            => [
    'ssh-rsa BBBBB3Nza...== jeff@puppetlabs.com',
    'ssh-dss BBBBB3Nza...== jeff@metamachine.net',
  ],
  password           => '!!',
}
