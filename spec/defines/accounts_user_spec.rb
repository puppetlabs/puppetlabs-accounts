require 'spec_helper'

describe '::accounts::user' do
  let(:title) { 'dan' }
  let(:params) { {} }
  let(:facts) do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
    }
  end

  describe 'expected defaults' do
    it { is_expected.to contain_user('dan').with('shell'      => '/bin/bash') }
    it { is_expected.to contain_user('dan').with('home'       => "/home/#{title}") }
    it { is_expected.to contain_user('dan').with('ensure'     => 'present') }
    it { is_expected.to contain_user('dan').with('comment'    => title) }
    it { is_expected.to contain_user('dan').with('gid'        => title) }
    it { is_expected.to contain_user('dan').with('groups'     => []) }
    it { is_expected.to contain_user('dan').with('managehome' => true) }
    it { is_expected.to contain_group('dan').with('ensure'    => 'present') }
    it { is_expected.to contain_group('dan').with('gid'       => nil) }
  end

  describe 'expected home defaults' do
    context 'normal user on linux' do
      let(:title) { 'dan' }

      it { is_expected.to contain_user('dan').with_home('/home/dan') }
    end
    context 'root user on linux' do
      let(:title) { 'root' }

      it { is_expected.to contain_user('root').with_home('/root') }
    end
    context 'normal user on Solaris' do
      let(:title) { 'dan' }
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
        }
      end

      it { is_expected.to contain_user('dan').with_home('/export/home/dan') }
    end
    context 'root user on Solaris' do
      let(:title) { 'root' }
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Solaris',
        }
      end

      it { is_expected.to contain_user('root').with_home('/') }
    end
  end

  describe 'when setting user parameters' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
      }
    end

    before(:each) do
      params['ensure']     = 'present'
      params['shell']      = '/bin/csh'
      params['comment']    = 'comment'
      params['home']       = '/var/home/dan'
      params['home_mode']  = '0755'
      params['uid']        = '123'
      params['gid']        = '456'
      params['group']      = 'dan'
      params['groups']     = ['admin']
      params['membership'] = 'inclusive'
      params['password']   = 'foo'
      params['sshkeys']    = ['1 2 3', '2 3 4']
    end

    it { is_expected.to contain_user('dan').with('ensure' => 'present') }
    it { is_expected.to contain_user('dan').with('shell' => '/bin/csh') }
    it { is_expected.to contain_user('dan').with('comment' => 'comment') }
    it { is_expected.to contain_user('dan').with('home' => '/var/home/dan') }
    it { is_expected.to contain_user('dan').with('uid' => '123') }
    it { is_expected.to contain_user('dan').with('gid' => 'dan') }
    it { is_expected.to contain_user('dan').with('groups' => ['admin']) }
    it { is_expected.to contain_user('dan').with('membership' => 'inclusive') }
    it { is_expected.to contain_user('dan').with('password' => 'foo') }
    it { is_expected.to contain_group('dan').with('ensure' => 'present') }
    it { is_expected.to contain_group('dan').with('gid' => '456') }
    it { is_expected.to contain_group('dan').that_comes_before('User[dan]') }
    it { is_expected.to contain_accounts__home_dir('/var/home/dan').with('user' => title) }
    it { is_expected.to contain_accounts__home_dir('/var/home/dan').with('mode' => '0755') }
    it { is_expected.to contain_accounts__home_dir('/var/home/dan').with('sshkeys' => ['1 2 3', '2 3 4']) }
    it { is_expected.to contain_file('/var/home/dan/.ssh') }

    describe 'when setting the user to absent' do
      # when deleting users the home dir is a File resource instead of a accounts::home_dir
      let(:contain_home_dir) { contain_file('/var/home/dan') }

      before(:each) do
        params['ensure'] = 'absent'
      end

      it { is_expected.to contain_user('dan').with('ensure' => 'absent') }
      it { is_expected.to contain_user('dan').that_comes_before('Group[dan]') }
      it { is_expected.to contain_group('dan').with('ensure' => 'absent') }
      it do
        is_expected.not_to contain_accounts__home_dir('/var/home/dan').with('ensure' => 'absent',
                                                                            'recurse' => true,
                                                                            'force' => true)
      end
    end

    describe 'when setting the user to absent with managehome off' do
      # when deleting users the home dir is a File resource instead of a accounts::home_dir
      let(:contain_home_dir) { contain_file('/var/home/dan') }

      before(:each) do
        params['ensure'] = 'absent'
        params['managehome'] = false
      end

      it { is_expected.not_to contain_home_dir }
      it { is_expected.not_to contain_file('/var/home/dan/.ssh') }
    end

    describe 'when setting the create_group to false' do
      before(:each) do
        params['group'] = 'foo'
        params['create_group'] = false
        params['ensure'] = 'present'
      end

      it { is_expected.not_to contain_group('foo') }
    end

    describe 'when setting the create_group to true' do
      before(:each) do
        params['group'] = 'foo'
        params['create_group'] = true
        params['ensure'] = 'present'
      end

      it { is_expected.to contain_group('foo') }
    end
  end

  describe 'when setting user parameters with empty password ignored if true' do
    before(:each) do
      params['ensure']                   = 'present'
      params['shell']                    = '/bin/csh'
      params['comment']                  = 'comment'
      params['home']                     = '/var/home/dan'
      params['home_mode']                = '0755'
      params['uid']                      = '123'
      params['gid']                      = '456'
      params['group']                    = 'dan'
      params['groups']                   = ['admin']
      params['membership']               = 'inclusive'
      params['password']                 = ''
      params['sshkeys']                  = ['1 2 3', '2 3 4']
      params['ignore_password_if_empty'] = true
    end
    it { is_expected.to contain_user('dan').without_password }
  end

  describe 'when setting user parameters with empty password not ignored if false' do
    before(:each) do
      params['ensure']                   = 'present'
      params['shell']                    = '/bin/csh'
      params['comment']                  = 'comment'
      params['home']                     = '/var/home/dan'
      params['home_mode']                = '0755'
      params['uid']                      = '123'
      params['gid']                      = '456'
      params['group']                    = 'dan'
      params['groups']                   = ['admin']
      params['membership']               = 'inclusive'
      params['password']                 = ''
      params['sshkeys']                  = ['1 2 3', '2 3 4']
      params['ignore_password_if_empty'] = false
    end
    it { is_expected.to contain_user('dan').with('password' => '') }
  end

  describe 'when setting user parameters with empty password not ignored by default' do
    before(:each) do
      params['ensure']                   = 'present'
      params['shell']                    = '/bin/csh'
      params['comment']                  = 'comment'
      params['home']                     = '/var/home/dan'
      params['home_mode']                = '0755'
      params['uid']                      = '123'
      params['gid']                      = '456'
      params['group']                    = 'dan'
      params['groups']                   = ['admin']
      params['membership']               = 'inclusive'
      params['password']                 = ''
      params['sshkeys']                  = ['1 2 3', '2 3 4']
    end
    it { is_expected.to contain_user('dan').with('password' => '') }
  end

  describe 'when setting user parameters with specified password not ignored if true' do
    before(:each) do
      params['ensure']                   = 'present'
      params['shell']                    = '/bin/csh'
      params['comment']                  = 'comment'
      params['home']                     = '/var/home/dan'
      params['home_mode']                = '0755'
      params['uid']                      = '123'
      params['gid']                      = '456'
      params['group']                    = 'dan'
      params['groups']                   = ['admin']
      params['membership']               = 'inclusive'
      params['password']                 = 'foo'
      params['sshkeys']                  = ['1 2 3', '2 3 4']
      params['ignore_password_if_empty'] = true
    end
    it { is_expected.to contain_user('dan').with('password' => 'foo') }
  end

  describe 'when setting user parameters with specified password not ignored if false' do
    before(:each) do
      params['ensure']                   = 'present'
      params['shell']                    = '/bin/csh'
      params['comment']                  = 'comment'
      params['home']                     = '/var/home/dan'
      params['home_mode']                = '0755'
      params['uid']                      = '123'
      params['gid']                      = '456'
      params['group']                    = 'dan'
      params['groups']                   = ['admin']
      params['membership']               = 'inclusive'
      params['password']                 = 'foo'
      params['sshkeys']                  = ['1 2 3', '2 3 4']
      params['ignore_password_if_empty'] = false
    end
    it { is_expected.to contain_user('dan').with('password' => 'foo') }
  end

  describe 'invalid parameter values' do
    it 'only accept absent and present for ensure' do
      params['ensure'] = 'invalid'
      is_expected.to raise_error Puppet::Error
    end
    it 'fails if locked is not a boolean' do
      params['locked'] = 'true'
      is_expected.to raise_error Puppet::Error
    end
    %w[home shell].each do |param|
      it "should fail is #{param} does not start with '/'" do
        params[param] = 'no_leading_slash'
        is_expected.to raise_error Puppet::Error
      end
    end
    it 'fails if gid is not composed of digits' do
      params['gid'] = 'name'
      is_expected.to raise_error Puppet::Error
    end
    it 'does not accept non-boolean values for locked' do
      params['locked'] = 'false'
      is_expected.to raise_error Puppet::Error
    end
    it 'does not accept non-boolean values for managehome' do
      params['managehome'] = 'false'
      is_expected.to raise_error Puppet::Error
    end
  end

  describe 'when locking users' do
    let(:params) { { 'locked' => true } }

    describe 'on debian' do
      before(:each) do
        facts['operatingsystem'] = 'debian'
        facts['osfamily'] = 'Debian'
      end
      it { is_expected.to contain_user('dan').with('shell' => '/usr/sbin/nologin') }
    end

    describe 'on ubuntu' do
      before(:each) do
        facts['operatingsystem'] = 'ubuntu'
        facts['osfamily'] = 'Ubuntu'
      end
      it { is_expected.to contain_user('dan').with('shell' => '/usr/sbin/nologin') }
    end

    describe 'on solaris' do
      before(:each) do
        facts['operatingsystem'] = 'solaris'
        facts['osfamily'] = 'Solaris'
      end
      it { is_expected.to contain_user('dan').with('shell' => '/usr/bin/false') }
    end

    describe 'on all other platforms' do
      before(:each) do
        facts['operatingsystem'] = 'anything_else'
        facts['osfamily'] = 'anything_else'
      end
      it { is_expected.to contain_user('dan').with('shell' => '/sbin/nologin') }
    end
  end

  describe 'with create_group => false' do
    before(:each) do
      params['create_group'] = false
    end
    it { is_expected.not_to contain_group('dan') }
  end

  describe 'when supplying resource defaults' do
    before(:each) do
      facts['osfamily'] = 'Debian'
      facts['operatingsystem'] = 'debian'
    end

    let(:pre_condition) { "Accounts::User{ shell => '/bin/zsh' }" }

    it { is_expected.to contain_user('dan').with('shell' => '/bin/zsh') }

    describe 'override defaults' do
      let(:params) { { 'shell' => '/bin/csh' } }

      it { is_expected.to contain_user('dan').with('shell' => '/bin/csh') }
    end

    describe 'locked overrides should override defaults and user params' do
      let(:params) { { 'shell' => '/bin/csh', 'locked' => true } }

      it { is_expected.to contain_user('dan').with('shell' => '/usr/sbin/nologin') }
    end
  end
end
