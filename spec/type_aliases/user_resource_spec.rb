# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Resource' do
  describe 'Valid user resource values' do
    [
      {},
      { 'ensure'                   => 'absent'                     },
      { 'allowdupe'                => false                        },
      { 'bash_profile_content'     => 'export foo=bar'             },
      { 'bash_profile_source'      => '/etc/defaults/bash_profile' },
      { 'bashrc_content'           => 'alias bar=foo'              },
      { 'bashrc_source'            => '/etc/profile'               },
      { 'comment'                  => 'Joe User'                   },
      { 'create_group'             => true                         },
      { 'expiry'                   => 'absent'                     },
      { 'forcelocal'               => false                        },
      { 'forward_content'          => 'root@localhost'             },
      { 'forward_source'           => '/root/.forward'             },
      { 'gid'                      => 0                            },
      { 'group'                    => 'root'                       },
      { 'groups'                   => []                           },
      { 'name'                     => 'root'                       },
      { 'home'                     => '/root'                      },
      { 'home_mode'                => '700'                        },
      { 'ignore_password_if_empty' => true                         },
      { 'iterations'               => 10_000                       },
      { 'locked'                   => false                        },
      { 'managehome'               => true                         },
      { 'managevim'                => false                        },
      { 'membership'               => 'inclusive'                  },
      { 'name'                     => 'root'                       },
      { 'password'                 => 'password123'                },
      { 'purge_sshkeys'            => true                         },
      { 'purge_user_home'          => false                        },
      { 'salt'                     => 'zyzzyx'                     },
      { 'shell'                    => '/bin/false'                 },
      { 'sshkey_custom_path'       => '/etc/ssh/local_keys/root'   },
      { 'sshkey_owner'             => 'root'                       },
      { 'sshkeys'                  => []                           },
      { 'system'                   => false                        },
      { 'uid'                      => 0                            },
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user resource values' do
    [
      { 'bogus'                    => true                         },
      { 'ensure'                   => false                        },
      { 'allowdupe'                => 'soitenly!'                  },
      { 'bash_profile_content'     => false                        },
      { 'bash_profile_source'      => nil                          },
      { 'bashrc_content'           => 1                            },
      { 'bashrc_source'            => []                           },
      { 'comment'                  => {}                           },
      { 'create_group'             => 'groupname'                  },
      { 'expiry'                   => 'never'                      },
      { 'forcelocal'               => -1                           },
      { 'forward_content'          => ['not', 'a', 'string']       },
      { 'forward_source'           => { '*' => 'root@localhost' }  },
      { 'gid'                      => 'nine'                       },
      { 'group'                    => 0                            },
      { 'groups'                   => [-1]                         },
      { 'name'                     => '$invalid'                   },
      { 'home'                     => 'C:\Users\Administrator'     },
      { 'home_mode'                => '999'                        },
      { 'ignore_password_if_empty' => 'always'                     },
      { 'iterations'               => 0                            },
      { 'locked'                   => []                           },
      { 'managehome'               => {}                           },
      { 'managevim'                => 'vim'                        },
      { 'membership'               => 'exclusive'                  },
      { 'password'                 => 123                          },
      { 'purge_sshkeys'            => 'no way'                     },
      { 'purge_user_home'          => []                           },
      { 'salt'                     => {}                           },
      { 'shell'                    => 'bash'                       },
      { 'sshkey_custom_path'       => '../../etc/ssh/key'          },
      { 'sshkey_owner'             => []                           },
      { 'sshkeys'                  => {}                           },
      { 'system'                   => 'Linux'                      },
      { 'uid'                      => -1                           },
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
