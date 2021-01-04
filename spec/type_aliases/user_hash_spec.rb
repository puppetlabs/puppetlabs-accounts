# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Hash' do
  describe 'Valid user hash values' do
    [
      { 'jdoe' => { 'comment'         => 'Jane Doe'                 } },
      { 'rroe' => { 'forward_content' => 'richard.roe@example.com'  } },
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user hash values' do
    [
      { '$$' => {}                                            },
      { '_a' => { 'ensure'                   => false       } },
      { '_b' => { 'allowdupe'                => 'soitenly!' } },
      { '_c' => { 'bash_profile_content'     => false       } },
      { '_d' => { 'bash_profile_source'      => nil         } },
      { '_e' => { 'bashrc_content'           => 1           } },
      { '_f' => { 'bashrc_source'            => []          } },
      { '_g' => { 'comment'                  => {}          } },
      { '_h' => { 'create_group'             => 'users'     } },
      { '_i' => { 'expiry'                   => 'never'     } },
      { '_j' => { 'forcelocal'               => -1          } },
      { '_k' => { 'forward_content'          => []          } },
      { '_l' => { 'forward_source'           => {}          } },
      { '_m' => { 'gid'                      => 'nine'      } },
      { '_n' => { 'group'                    => 0           } },
      { '_o' => { 'groups'                   => [-1]        } },
      { '_p' => { 'name'                     => '$invalid'  } },
      { '_q' => { 'home'                     => 'C:\\'      } },
      { '_r' => { 'home_mode'                => '999'       } },
      { '_s' => { 'ignore_password_if_empty' => 'always'    } },
      { '_t' => { 'iterations'               => 0           } },
      { '_u' => { 'locked'                   => []          } },
      { '_v' => { 'managehome'               => {}          } },
      { '_w' => { 'managevim'                => 'vim'       } },
      { '_x' => { 'membership'               => 'exclusive' } },
      { '_y' => { 'password'                 => 123         } },
      { '_z' => { 'purge_sshkeys'            => 'no way'    } },
      { '_0' => { 'purge_user_home'          => []          } },
      { '_1' => { 'salt'                     => {}          } },
      { '_2' => { 'shell'                    => 'bash'      } },
      { '_3' => { 'sshkey_custom_path'       => '../../etc' } },
      { '_4' => { 'sshkey_owner'             => []          } },
      { '_5' => { 'sshkeys'                  => {}          } },
      { '_6' => { 'system'                   => 'Linux'     } },
      { '_7' => { 'uid'                      => -1          } },
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
