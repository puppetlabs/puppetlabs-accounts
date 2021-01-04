# frozen_string_literal: true

require 'spec_helper'

describe 'accounts::user' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:user_vars) do
        case facts[:os]['family']
        when 'Debian'
          { dan_home:     '/home/dan',
            locked_shell: '/usr/sbin/nologin',
            root_home:    '/root' }
        when 'Solaris'
          { dan_home:     '/export/home/dan',
            locked_shell: '/usr/bin/false',
            root_home:    '/' }
        else
          { dan_home:     '/home/dan',
            locked_shell: '/sbin/nologin',
            root_home:    '/root' }
        end
      end

      context "for user dan on #{facts[:os]['family']}" do
        let(:title) { 'dan' }

        describe 'expected defaults' do
          let(:params) { {} }

          it do
            is_expected.to contain_user(title).with('shell'        => '/bin/bash')
            is_expected.to contain_user(title).with('home'         => user_vars[:dan_home])
            is_expected.to contain_user(title).with('ensure'       => 'present')
            is_expected.to contain_user(title).with('comment'      => title)
            is_expected.to contain_user(title).with('gid'          => title)
            is_expected.to contain_user(title).with('groups'       => [])
            is_expected.to contain_user(title).with('allowdupe'    => false)
            is_expected.to contain_user(title).with('managehome'   => true)
          end
          it do
            is_expected.to contain_group(title).with('ensure'      => 'present')
            is_expected.to contain_group(title).with('gid'         => nil)
          end
        end

        describe 'when setting user parameters' do
          let(:params) do
            {
              ensure:           'present',
              allowdupe:        true,
              comment:          'comment',
              expiry:           '2018-06-22',
              gid:              456,
              group:            'dan',
              groups:           ['admin'],
              home:             '/var/home/dan',
              home_mode:        '0755',
              membership:       'inclusive',
              password:         'foo',
              password_max_age: 60,
              shell:            '/bin/csh',
              sshkey_owner:     'dan',
              sshkeys:          ['ssh-rsa AAAAB3Nza...LiPk== dan@example1.net',
                                 'permitopen="192.0.2.1:80",permitopen="192.0.2.2:25" ssh-dss AAAAB5...21S== dan key2',
                                 'command="/bin/echo Hello World",from="myhost.exapmle.com,192.168.1.1" ecdsa-sha2-nistp521 test_key vagrant2'],
              uid:              123,
            }
          end

          [:ensure, :allowdupe, :comment, :expiry, :groups, :home,
           :membership, :password, :password_max_age].each do |param|
            it { is_expected.to contain_user(title).with(param.to_s => params[param]) }
          end
          it do
            is_expected.to contain_user(title).with('gid' => params[:group])
            is_expected.to contain_group(params[:group]).with('ensure' => params[:ensure],
                                                              'gid'    => params[:gid])
          end
          it { is_expected.to contain_group(params[:group]).that_comes_before("User[#{title}]") }
          it do
            is_expected.to contain_accounts__home_dir(params[:home]).with('user' => title,
                                                                          'mode' => params[:home_mode])
          end
          it { is_expected.to contain_accounts__key_management("#{title}_key_management").with('sshkeys' => params[:sshkeys]) }
          it { is_expected.to contain_ssh_authorized_key("#{params[:sshkey_owner]}_ssh-rsa_dan@example1.net_1e44b207704970cf4acb3470331b0e5c") }
          it { is_expected.to contain_ssh_authorized_key("#{params[:sshkey_owner]}_ssh-dss_dan key2_6e9b8958712502a8b31e1c283b6e6fce") }
          it { is_expected.to contain_ssh_authorized_key("#{params[:sshkey_owner]}_ecdsa-sha2-nistp521_vagrant2_8c32d1183251df9828f929b935ae0419") }
          it { is_expected.to contain_file("#{params[:home]}/.ssh") }
        end

        describe 'when locking users' do
          let(:params) { { 'locked' => true } }

          it { is_expected.to contain_user(title).with('shell' => user_vars[:locked_shell]) }
        end

        describe 'when setting custom sshkey location' do
          let(:params) { { sshkey_custom_path: '/var/lib/ssh/dan/custom_key_file' } }

          it { is_expected.to contain_file(params[:sshkey_custom_path]) }
        end

        describe 'when setting sshkey mode on custom sshkey location' do
          let(:params) do
            { sshkey_mode:        '0440',
              sshkey_custom_path: '/var/lib/ssh/dan/custom_key_file' }
          end

          it { is_expected.to contain_file(params[:sshkey_custom_path]).with(mode: '0440') }
        end

        describe 'with create_group set to false' do
          let(:params) do
            { group:        'foo',
              create_group: false,
              ensure:       'present' }
          end

          it { is_expected.not_to contain_group(params[:group]) }
        end

        describe 'with create_group set to true' do
          let(:params) do
            { group:        'foo',
              create_group: true,
              ensure:       'present' }
          end

          it { is_expected.to contain_group(params[:group]) }
        end

        describe 'with forcelocal set to false' do
          let(:params) do
            { forcelocal: false }
          end

          it { is_expected.to contain_user(title).with('forcelocal' => params[:forcelocal]) }
          it { is_expected.to contain_group(title).with('forcelocal' => params[:forcelocal]) }
        end

        describe 'with forcelocal set to true' do
          let(:params) do
            { forcelocal: true }
          end

          it { is_expected.to contain_user(title).with('forcelocal' => params[:forcelocal]) }
          it { is_expected.to contain_group(title).with('forcelocal' => params[:forcelocal]) }
        end

        describe 'when empty password ignored' do
          let(:params) do
            { ignore_password_if_empty: true,
              password:                 '' }
          end

          it { is_expected.to contain_user(title).without_password }
        end

        describe 'when empty password not ignored explicitly' do
          let(:params) do
            { ignore_password_if_empty: false,
              password:                 '' }
          end

          it { is_expected.to contain_user(title).with('password' => params[:password]) }
        end

        describe 'when empty password not ignored by default' do
          let(:params) { { password: '' } }

          it { is_expected.to contain_user(title).with('password' => params[:password]) }
        end

        describe 'when non-empty password not ignored' do
          let(:params) do
            { ignore_password_if_empty: false,
              password:                 'foo' }
          end

          it { is_expected.to contain_user(title).with('password' => params[:password]) }
        end

        describe 'when non-empty password ignored if empty' do
          let(:params) do
            { ignore_password_if_empty: true,
              password:                 'foo' }
          end

          it { is_expected.to contain_user(title).with('password' => params[:password]) }
        end

        describe 'when setting password iterations and salt' do
          let(:params) do
            { iterations: 5,
              salt:       'bar' }
          end

          it { is_expected.to contain_user(title).with('iterations' => params[:iterations]) }
          it { is_expected.to contain_user(title).with('salt'       => params[:salt]) }
        end

        describe 'when using a sensitive password' do
          let(:params) do
            { password: RSpec::Puppet::RawString.new("Sensitive('foo')") }
          end

          it { is_expected.to contain_user(title).with('password' => sensitive('foo')) }
        end

        describe 'when supplying resource defaults' do
          let(:params) { {} }
          let(:pre_condition) { "Accounts::User{ shell => '/bin/zsh' }" }

          it { is_expected.to contain_user(title).with('shell' => '/bin/zsh') }
        end

        describe 'when explicit parameters override defaults' do
          let(:params) { { 'shell' => '/bin/csh' } }
          let(:pre_condition) { "Accounts::User{ shell => '/bin/zsh' }" }

          it { is_expected.to contain_user(title).with('shell' => '/bin/csh') }
        end

        describe 'when locked overrides defaults and user params' do
          let(:params) do
            { 'locked' => true,
              'shell' => '/bin/csh' }
          end
          let(:pre_condition) { "Accounts::User{ shell => '/bin/zsh' }" }

          it { is_expected.to contain_user(title).with('shell' => user_vars[:locked_shell]) }
        end

        context 'when setting the user to absent' do
          # when deleting users the home dir is a File resource instead of a accounts::home_dir
          let(:contain_home_dir) { contain_file(params[:home]) }

          describe 'with default sshkey path' do
            let(:params) do
              { ensure:         'absent',
                purge_user_home: true }
            end

            it { is_expected.to contain_user(title).with('ensure' => params[:ensure]) }
            it { is_expected.to contain_user(title).that_comes_before("Group[#{title}]") }
            it { is_expected.to contain_group(title).with('ensure' => params[:ensure]) }
            it { is_expected.not_to contain_accounts__home_dir(user_vars[:dan_home]) }
          end

          describe 'with custom sshkey location' do
            let(:params) do
              { ensure:             'absent',
                purge_user_home:    true,
                sshkey_custom_path: '/var/lib/ssh/dan/custom_key_file' }
            end

            it { is_expected.to contain_file(params[:sshkey_custom_path]).with('ensure' => params[:ensure]).that_comes_before("User[#{title}]") }
          end

          describe 'with purge_user_home off' do
            let(:params) do
              { ensure:         'absent',
                purge_user_home: false }
            end

            it { is_expected.to contain_user(title).with('ensure'     => params[:ensure]) }
            it { is_expected.to contain_user(title).with('managehome' => params[:purge_user_home]) }
            it { is_expected.not_to contain_accounts__home_dir(user_vars[:dan_home]) }
            it { is_expected.not_to contain_file("#{user_vars[:dan_home]}/.ssh") }
          end
        end
      end

      context 'for user root' do
        let(:title) { 'root' }
        let(:params) { {} }

        describe 'expected defaults' do
          it { is_expected.to contain_user(title).with_home(user_vars[:root_home]) }
        end
      end

      context 'invalid parameter values' do
        let(:title) { 'dan' }

        describe "only accepts 'absent' and 'present' for ensure" do
          let(:params) { { ensure: 'invalid' } }

          it { is_expected.to raise_error Puppet::Error }
        end
        [:home, :shell].each do |param|
          describe "should fail if #{param} does not start with '/'" do
            let(:params) { { param => 'no_leading_slash' } }

            it { is_expected.to raise_error Puppet::Error }
          end
        end
        describe 'does not accept non-date values for expiry' do
          let(:params) { { expiry: 'notadate' } }

          it { is_expected.to raise_error Puppet::Error }
        end
        [:gid, :uid].each do |param|
          describe "fails if #{param} is not composed of digits" do
            let(:params) { { param => 'name' } }

            it { is_expected.to raise_error Puppet::Error }
          end
        end
        [:allowdupe, :expiry, :locked, :managehome,
         :managevim, :purge_user_home].each do |param|
          describe "fails if #{param} is not a boolean" do
            let(:params) { { param => 'true' } }

            it { is_expected.to raise_error Puppet::Error }
          end
        end
      end
    end
  end
end
