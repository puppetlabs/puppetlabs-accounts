require 'spec_helper_acceptance'

describe 'accounts::user define', :unless => UNSUPPORTED_PLATFORMS.include?(fact("osfamily")) do
  describe 'main tests' do
    describe user('hunner') do
      it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles' do
        pp = <<-EOS
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
              'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant',
            ],
          }
        EOS
        apply_manifest(pp, :catch_failures => true)
      end
      it { should exist }
      it { should belong_to_group 'hunner' }
      it { should belong_to_group 'root' }
      it { should have_login_shell '/bin/true' }
      it { should have_home_directory '/test/hunner' }
      it { should contain_password 'hi' }
      # Solaris 10's /bin/sh can't expand ~username paths and thus can't read ~hunner/.ssh/authorized_keys
      it("should have authorized_key", :unless => default['platform'].match(/solaris-10/)) { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant' }
    end
    describe file('/test/hunner') do
      it { should be_directory }
      it { should be_mode 700 }
      it { should be_owned_by 'hunner' }
      it { should be_grouped_into 'hunner' }
    end
    describe file('/test/hunner/.bashrc') do
      its(:content) { should match(/managed by Puppet/) }
    end
    describe file('/test/hunner/.bash_profile') do
      its(:content) { should match(/Get the aliases and functions/) }
    end
    describe file('/test/hunner/.vim') do
      it { should be_directory }
    end
  end
  describe 'warn for sshkeys without managehome' do
    it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles' do
      pp = <<-EOS
        accounts::user { 'hunner':
          managehome => false,
          sshkeys    => [
            'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant',
          ],
        }
      EOS
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).to match(/Warning:.*ssh keys were passed for user hunner/)
      end
    end
  end
  describe 'locking users' do
    describe user('hunner') do
      it 'locks a user' do
        pp = <<-EOS
          accounts::user { 'hunner':
            locked => true,
          }
        EOS
        apply_manifest(pp, :catch_failures => true)
      end
      it { 
        case fact('osfamily')
        when 'Debian'
          should have_login_shell '/usr/sbin/nologin'
        when 'Solaris'
          should have_login_shell '/usr/bin/false'
        else
          should have_login_shell '/sbin/nologin'
        end
      }
    end
  end
  describe 'create user with custom group name' do
    describe user('cuser') do
      it 'creates group of matching names, assigns non-matching group, manages homedir' do
        pp = <<-EOS
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
        apply_manifest(pp, :catch_failures => true)
      end
      it { should exist }
      it { should belong_to_group 'staff' }
      it { should have_home_directory '/test/cuser' }
    end
    describe file('/test/cuser') do
      it { should be_directory }
      it { should be_mode 700 }
      it { should be_owned_by 'cuser' }
      it { should be_grouped_into 'staff' }
    end
  end
  describe 'ignore password if ignore set to true' do
    describe user('ignore_user') do
      it 'creates group of matching names, assigns non-matching group, empty password, ignore true, ignores password' do
        pp = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['ignore_user'],
          }
          accounts::user { 'ignore_user':
            group                    => 'staff',
            password                 => 'foo',
          }
        EOS
        apply_manifest(pp, :catch_failures => true)
        pp = <<-EOS
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
        apply_manifest(pp, :catch_failures => true)
      end
      it { should exist }
      it { should contain_password 'foo' }
    end
  end
  describe 'do not ignore password if ignore set to false' do
    describe user('no_ignore_user') do
      it 'creates group of matching names, assigns non-matching group, empty password, ignore false, should not ignore password' do
        pp = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['no_ignore_user'],
          }
          accounts::user { 'no_ignore_user':
            group                    => 'staff',
            password                 => 'foo',
          }
        EOS
        apply_manifest(pp, :catch_failures => true)
        pp = <<-EOS
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
        apply_manifest(pp, :catch_failures => true)
      end
      it { should exist }
      it { should contain_password '' }
    end
  end
  describe 'do not ignore password if set and ignore set to true' do
    describe user('specd_user') do
      it 'creates group of matching names, assigns non-matching group, specify password, ignore, should not ignore password' do
        pp = <<-EOS
          file { '/test':
            ensure => directory,
            before => Accounts::User['specd_user'],
          }
          accounts::user { 'specd_user':
            group                    => 'staff',
            password                 => 'foo',
          }
          EOS
        apply_manifest(pp, :catch_failures => true)
        pp = <<-EOS
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
        apply_manifest(pp, :catch_failures => true)
      end
      it { should exist }
      it { should contain_password 'bar' }
    end
  end
end
