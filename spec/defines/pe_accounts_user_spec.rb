require 'puppet'
require 'rspec-puppet'
describe 'pe_accounts::user', :type => :define do
  # assume the tests are in a module
  let(:module_path) { File.join(File.dirname(__FILE__), '../../../') }
  let(:title) { "dan" }
  let(:params) { {} }
  let(:facts) { {} }

  let(:contain_user) { create_resource('user', 'dan') }
  let(:contain_group) { create_resource('group', 'dan') }
  let(:contain_home_dir) { create_resource('pe_accounts::home_dir', '/var/home/dan') }

  describe 'expected defaults' do
    it { should contain_user.with_param('shell', '/bin/bash') }
    it { should contain_user.with_param('home', "/home/#{title}") }
    it { should contain_user.with_param('ensure', 'present') }
    it { should contain_user.with_param('comment', title) }
    it { should contain_user.with_param('groups', []) }
    it { should contain_group.with_param('ensure', 'present') }
    it { should contain_group.with_param('gid', nil) }
  end

  describe 'when setting user parameters' do
    before do
      params['ensure']     = 'present'
      params['shell']      = '/bin/csh'
      params['comment']    = 'comment'
      params['home']       = '/var/home/dan'
      params['uid']        = '123'
      params['gid']        = '456'
      params['groups']     = ['admin']
      params['membership'] = 'inclusive'
      params['password']   = 'foo'
      params['sshkeys']    = ['1 2 3', '2 3 4']
    end

    it { should contain_user.with_param('ensure', 'present') }
    it { should contain_user.with_param('shell', '/bin/csh') }
    it { should contain_user.with_param('comment', 'comment') }
    it { should contain_user.with_param('home', '/var/home/dan') }
    it { should contain_user.with_param('uid', '123') }
    it { should contain_user.with_param('gid', '456') }
    it { should contain_user.with_param('groups', 'admin') }
    it { should contain_user.with_param('membership', 'inclusive') }
    it { should contain_user.with_param('password', 'foo') }
    it { should contain_group.with_param('ensure', 'present') }
    it { should contain_group.with_param('gid', '456') }
    it { should contain_group.with_param('before', 'User[dan]') }
    it { should contain_home_dir.with_param('user', title) }
    it { should contain_home_dir.with_param('sshkeys', ['1 2 3', '2 3 4']) }

    describe 'when setting the user to absent' do

      # when deleting users the home dir is a File resource instead of a pe_accounts::home_dir
      let(:contain_home_dir) { contain_file('/var/home/dan') }

      before do
        params['ensure'] = 'absent'
      end

      it { should contain_user.with_param('ensure', 'absent') }
      it { should contain_user.with_param('before', 'Group[dan]') }
      it { should contain_group.with_param('ensure', 'absent') }
      it do
        should contain_home_dir.with({
          'ensure' => 'absent',
          'recurse' => true,
          'force' => true
        })
      end

      describe 'with managehome off' do

        before do
          params['managehome'] = false
        end

        it { should_not contain_home_dir }
      end
    end
  end

  describe 'invalid parameter values' do
    it 'should only accept absent and present for ensure' do
      params['ensure'] = 'invalid'
      expect { subject }.should raise_error
    end
    it 'should fail if locked is not a boolean' do
      params['locked'] = 'true'
      expect { subject }.should raise_error
    end
    ['home', 'shell'].each do |param|
      it "should fail is #{param} does not start with '/'" do
        params[param] = 'no_leading_slash'
        expect { subject }.should raise_error
      end
    end
    it 'should fail if gid is not composed of digits' do
      params['gid'] = 'name'
      expect { subject }.should raise_error
    end
    it 'should not accept non-boolean values for locked' do
      params['locked'] = 'false'
      expect { subject }.to raise_error
    end
    it 'should not accept non-boolean values for managehome' do
      params['managehome'] = 'false'
      expect { subject }.to raise_error
    end
  end

  describe 'when locking users' do

    let(:params) { { 'locked' => true } }

    describe 'on debian' do
      before { facts['operatingsystem'] = 'debian' }
      it { should contain_user.with_param('shell', '/usr/sbin/nologin') }
    end

    describe 'on ubuntu' do
      before { facts['operatingsystem'] = 'ubuntu' }
      it { should contain_user.with_param('shell', '/usr/sbin/nologin') }
    end

    describe 'on solaris' do
      before { facts['operatingsystem'] = 'solaris' }
      it { should contain_user.with_param('shell', '/usr/bin/false') }
    end

    describe 'on all other platforms' do
      before { facts['operatingsystem'] = 'anything_else' }
      it { should contain_user.with_param('shell', '/sbin/nologin') }
    end
  end

  describe 'when supplying resource defaults' do

    let(:pre_condition) { "Pe_accounts::User{ shell => '/bin/zsh' }" }

    it { should contain_user.with_param('shell', '/bin/zsh') }

    describe 'override defaults' do
      let(:params) { { 'shell' => '/bin/csh' } }
      it { should contain_user.with_param('shell', '/bin/csh') }
    end

    describe 'locked overrides should override defaults and user params' do
      let(:params) { { 'shell' => '/bin/csh', 'locked' => true} }
      it { should contain_user.with_param('shell', '/sbin/nologin') }
    end
  end
end
