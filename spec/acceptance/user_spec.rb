require 'spec_helper_acceptance'

test_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8Hfd'\
           'OV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9W'\
           'hQ=='

pp_accounts_define = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['hunner'],
          }
          accounts::user { 'hunner':
            groups               => ['root'],
            password             => 'hi',
            shell                => '/bin/true',
            home                 => '/test/hunner',
            bashrc_content       => file('accounts/shell/bashrc'),
            bash_profile_content => file('accounts/shell/bash_profile'),
            sshkeys              => [
              'ssh-rsa #{test_key} vagrant',
              'from="myhost.example.com,192.168.1.1" ssh-rsa #{test_key} vagrant2'
            ],
          }
EOS

pp_without_managehome = <<-EOS
        accounts::user { 'hunner':
          managehome => false,
          sshkeys    => [
            'ssh-rsa #{test_key} vagrant',
          ],
        }
EOS

pp_locked_user = <<-EOS
          accounts::user { 'hunner':
            locked => true,
          }
EOS

pp_custom_group_name = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['cuser'],
          }
          accounts::user { 'cuser':
            group                => 'staff',
            password             => '!!',
            home                 => '/test/cuser',
          }
EOS

pp_create_group_false = <<-EOS
          accounts::user { 'grp_flse':
            group                => 'newgrp_1',
            create_group         => false,
            home                 => '/test/grp_flse',
          }
EOS

pp_create_group_true = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['grp_true'],
          }
          accounts::user { 'grp_true':
            group                => 'newgrp_2',
            create_group         => true,
            home                 => '/test/grp_true',
          }
EOS

pp_ignore_user_first_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['ignore_user'],
          }
          accounts::user { 'ignore_user':
            group                    => 'staff',
            password                 => 'foo',
          }
EOS

pp_ignore_user_second_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['ignore_user'],
          }
          accounts::user { 'ignore_user':
            group                    => 'staff',
            password                 => '',
            ignore_password_if_empty => true,
          }
EOS

pp_no_ignore_user_first_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['no_ignore_user'],
          }
          accounts::user { 'no_ignore_user':
            group                    => 'staff',
            password                 => 'foo',
          }
EOS

pp_no_ignore_user_second_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['no_ignore_user'],
          }
          accounts::user { 'no_ignore_user':
            group                    => 'staff',
            password                 => '',
            ignore_password_if_empty => false,
          }
EOS

pp_specd_user_first_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['specd_user'],
          }
          accounts::user { 'specd_user':
            group                    => 'staff',
            password                 => 'foo',
          }
EOS

pp_specd_user_second_run = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['specd_user'],
          }
          accounts::user { 'specd_user':
            group                    => 'staff',
            password                 => 'bar',
            ignore_password_if_empty => true,
          }
EOS

describe 'accounts::user define', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe 'main tests' do
    describe user('hunner') do
      it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles' do
        apply_manifest(pp_accounts_define, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to belong_to_group 'hunner' }
      it { is_expected.to belong_to_group 'root' }
      it { is_expected.to have_login_shell '/bin/true' }
      it { is_expected.to have_home_directory '/test/hunner' }
      # Solaris does not offer a means of testing the password
      it('contains password', unless: default['platform'].match(%r{solaris})) { is_expected.to contain_password 'hi' }
      # Solaris 10's /bin/sh can't expand ~username paths and thus can't read ~hunner/.ssh/authorized_keys
      it('has authorized_key - vagrant', unless: default['platform'].match(%r{solaris-10})) {
        is_expected.to have_authorized_key "ssh-rsa #{test_key} vagrant"
      }
      it('has authorized_key - vagrant2', unless: default['platform'].match(%r{solaris-10})) {
        is_expected.to have_authorized_key "from=\"myhost.example.com,192.168.1.1\" ssh-rsa #{test_key} vagrant2"
      }
    end
    describe file('/test/hunner') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
      it { is_expected.to be_owned_by 'hunner' }
      it { is_expected.to be_grouped_into 'hunner' }
    end
    describe file('/test/hunner/.bashrc') do
      its(:content) { is_expected.to match(%r{managed by Puppet}) }
    end
    describe file('/test/hunner/.bash_profile') do
      its(:content) { is_expected.to match(%r{Get the aliases and functions}) }
    end
    describe file('/test/hunner/.vim') do
      it { is_expected.to be_directory }
    end
  end
  describe 'warn for sshkeys without managehome' do
    it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles' do
      apply_manifest(pp_without_managehome, catch_failures: true) do |r|
        expect(r.stderr).to match(%r{Warning:.*ssh keys were passed for user hunner})
      end
    end
  end
  describe 'locking users' do
    describe user('hunner') do
      it 'locks a user' do
        apply_manifest(pp_locked_user, catch_failures: true)
      end
      login_shell = '/sbin/nologin'
      case fact('osfamily')
      when 'Debian'
        login_shell = '/usr/sbin/nologin'
      when 'Solaris'
        login_shell = '/usr/bin/false'
      end
      it {
        is_expected.to have_login_shell login_shell
      }
    end
  end
  describe 'create user with custom group name' do
    describe user('cuser') do
      it 'creates group of matching names, assigns non-matching group, manages homedir' do
        apply_manifest(pp_custom_group_name, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to belong_to_group 'staff' }
      it { is_expected.to have_home_directory '/test/cuser' }
    end
    describe file('/test/cuser') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
      it { is_expected.to be_owned_by 'cuser' }
      it { is_expected.to be_grouped_into 'staff' }
    end
  end
  describe 'group set to false does not create group' do
    describe user('grp_flse') do
      it 'does not create group' do
        apply_manifest(pp_create_group_false, expect_failures: true) do |r|
          expect(r.stderr).to match(%r{(.*group '?newgrp_1'? does not exist.*|.*Unknown group `?newgrp_1'?.*)})
        end
      end
      it { is_expected.not_to exist }
      it { is_expected.not_to belong_to_group 'new_group_1' }
    end
  end
  describe 'group set to true creates group' do
    describe user('grp_true') do
      it 'creates group' do
        apply_manifest(pp_create_group_true, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to belong_to_group 'newgrp_2' }
    end
  end
  # Solaris does not offer a means of testing the password
  describe 'ignore password if ignore set to true', unless: default['platform'].match(%r{solaris}) do
    describe user('ignore_user') do
      it 'creates group of matching names, assigns non-matching group, empty password, ignore true, ignores password' do
        apply_manifest(pp_ignore_user_first_run, catch_failures: true)
        apply_manifest(pp_ignore_user_second_run, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to contain_password 'foo' }
    end
  end
  # Solaris does not offer a means of testing the password
  describe 'do not ignore password if ignore set to false', unless: default['platform'].match(%r{solaris}) do
    describe user('no_ignore_user') do
      it 'creates group of matching names, assigns non-matching group, empty password, ignore false, should not ignore password' do
        apply_manifest(pp_no_ignore_user_first_run, catch_failures: true)
        apply_manifest(pp_no_ignore_user_second_run, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to contain_password '' }
    end
  end
  describe 'do not ignore password if set and ignore set to true', unless: default['platform'].match(%r{solaris}) do
    describe user('specd_user') do
      it 'creates group of matching names, assigns non-matching group, specify password, ignore, should not ignore password' do
        apply_manifest(pp_specd_user_first_run, catch_failures: true)
        apply_manifest(pp_specd_user_second_run, catch_failures: true)
      end
      it { is_expected.to exist }
      it { is_expected.to contain_password 'bar' }
    end
  end
end
