node default {
  # We can set some default properties for all accounts managed by the pe_accounts
  # module
  Pe_accounts::User {
    ensure => present,
    shell  => '/bin/bash',
  }

  # A simple resource declaration using the pe_accounts module provides much
  # more than the Puppet native user type.  For example, the home directory will
  # be managed, a primary group created, initial bashrc and authorized_keys file
  # created and managed...
  pe_accounts::user { 'linus':
    ensure => present,
  }

  # In addition, we can manage a great many things related to accounts
  # This password is 'puppet'
  pe_accounts::user { 'jeff':
    ensure     => present, # present, absent
    comment    => 'Jeff McCune',
    uid        => 1112,
    gid        => 1112,
    groups     => [ 'admin', 'developer' ],
    membership => 'inclusive', # how to manage group membership: inclusive, minimum
    home       => '/home/jeff',
    password   => '$1$JSI6ru4o$aZYLo.0cjVp4ai/Lr0ljJ.', # 'puppet', can be copied from /etc/shadow
    locked     => false,
    sshkeys    => [ 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff@puppetlabs.com' ],
  }

}
