node default {
  # Make sure to declare data classes before accessing them.
  class { 'site::pe_accounts::data': }

  # This example uses the default behavior of adding resources to the Puppet
  # catalog using a Hash data structure defined in a user provided namespace.
  notify { 'alpha': }
  ->
  class { 'pe_accounts':
    data_store     => 'namespace',
    data_namespace => 'site::pe_accounts::data',
  }
  ->
  notify { 'omega': }

  # The end user is also able to declare accounts using the defined resource type
  # we provide.
  pe_accounts::user { 'bob':
    uid      => 4001,
    gid      => 4001,
    shell    => '/bin/bash',
    password => '!!',
    sshkeys  => "${::site::pe_accounts::data::users_hash['jeff']['sshkeys']}-2",
    locked   => false,
  }
}

class site::pe_accounts::data {
  # The groups_hash defines "shared" supplementary groups.
  $groups_hash = {
    'admin'     => { gid => '3000' },
    'sudo'      => { gid => '3001' },
    'sudonopw'  => { gid => '3002' },
    'developer' => { gid => '3003' },
    'ops'       => { gid => '3004' },
  }

  # These are the actual accounts on the system to manage
  $users_hash = {
    'jeff' => {
      'shell'    => '/bin/zsh',
      'comment'  => 'Jeff McCune',
      'groups'   => [ admin, sudonopw, ],
      'uid'      => '1112',
      'gid'      => '1112',
      'locked'   => true,
      'sshkeys'  => [
        'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzlnWpbiDfBLJWWh3xEIMo3QJhB+/TucyWtqTB3B3np1LHi7/zJW9L5KwqgCPfcCSPKY4ekW4K5DwZgXufM74+acBJqAIioJby5AVlkYtRMuJItzRYfkClN0Ex/8rCc/y8T+Wa5Q7Kyy73312xxqbeO8nzNkDO2Zx2oxxHVDSeThX5+Tk1lFj3LpsWbuTsImK9KsVPX50M6uNQxSt4ASx0SDe0MDLC5uzbGYtjqkZQYEYguo7O64t81+C3JK3BHDPsL5G5H7g2qwPJ7ola1sV1wDCGE9ago09QZvYpOacPbtbesFhbwKP31eDz2PWGSJ4DCIoLKhmfpEuDpiih649VQ== jeff@puppetlabs.com',
        'ssh-dss AAAAB3NzaC1kc3MAAAEBAPCj/IWTwTQ59/tCPpq8fAV20ZcxZbGsv3pQ3kAjZgJmSy3bgFtQxVgvyETi2vXzoSDVeKp6zx9/kXHWDYu9U+v3S2B5453qm/RTIc8wpbU9jVblvkgf0616kF8KJdzHik/Ujaxbq4Gcn6wide8IdiOVW7vVnhkrmuuPVYOHAuP+U+Vv91H2o9dEy6Jtr4kNUyuHFXD2FLX9xb4YceMU6vfCOp2Asx+t9aKNN5lhgpBGNcVwouiMmRY/CQghIUjKfLoTvd/j33OwDMDdGWwF3BYbugGTZ4J5abVRL3RepoKG5wl3xMxBYF5vgcom8PQJuKFKwP3SFoQjPFh7aFeeQ2kAAAAVAKQwZvAHRvzBUzdPUqIGsXOxO397AAABAE2c/WnW9PnTxRJ6zTGWHGuvgOFSQHGvUJ6ZjZvf4HTGaFb2/h2XevD4718qYZNXSzPWoajXTXj7+cdYbN4PzGLbpUO3s8lbcDxcsD1Ow1XYubrwD1EUQljMfGzHIhaMhqnfx4fKY9HOCeog17EUmpLReMH2UTrENfI6sn0YaWz2tbe2Zbk4w6MZvDA6K+5I4DiVOOtx1JO+1sbIQp6GS2olOE2wntaW/ICLlQK65c3kBS6Q9XkFTPfWuosfaUYBuC+4a1LVtKj3o3a7b/kjDzmub/x/49+7mjN9d+/Hlk854J7L3HNUf5mkiqKQb9bA1ci/WqpODaVTUhts9dLmo5oAAAEAVlD4/6U/I24jIq4ftZ7GjS9c8NKK31AXYKKQXZRI0+n0qQ+vRnl8vKHSSkCHS7Jbh5MtToUKL8hJDMfA1pD0gywy1kSVHVY+i0M5zok3NWmefVyFG5fW7I7MDEkrmqzfcF6b4zKX4LD8hCZS6zAzrG5umFTWkgrR+f+5yrR7w6Y3TcSmbPvmR0dfleUfl4VF/lqmrDsKqWutL/VqKvxcFXFW7wZw5CviC7vAICRUrOiYTDFG9ZeA5CFKJ18YMPkuvfgQdwhWVImZ2AHtZJ0i+s03sV20tScg+JMuxIwFYFKp6Gic9Q9+YvfDzkr+668uALmHbvBuIr58SZUXyIV8gA== jmccune+2008-05-16', ],
    },
    'dan' => {
      'comment'  => 'Dan Bode',
      'uid'      => '1109',
      'gid'      => '1109',
    },
    'nigel' => {
      'comment'  => 'Nigel Kersten',
      'uid'      => '2001',
      'gid'      => '2001',
    },
  }
}
