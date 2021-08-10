# frozen_string_literal: true

require 'spec_helper_acceptance'

test_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8Hfd'\
           'OV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9W'\
           'hQ=='
ecdsa_test_key = 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNlpEm6+RwCiQXgQAb0P1asEAxCJDVtm/YYyUbdSifCbri98fjs1C/03pm9yLRQ0W/S70S8AhDCMjVFA07WzjOQ='
ecdsa_sk_test_key = 'AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAjkGvdKC05udQc82xGWWSKHbmJyBoa/oCq+2FiU6udqQyx0uOEC3YZAjvygBSdIo5vCpDELqJxaNQGQEkeUyYYAAAAEc3NoOg=='

pp_accounts_define = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['hunner'],
  }
  if $facts['puppetversion'][0] == '6' {
    $key_test = [
      'ssh-rsa #{test_key} vagrant',
      'command="/bin/echo Hello",from="myhost.example.com,192.168.1.1" ssh-rsa #{test_key} vagrant2'
    ]
  }
  else {
    $key_test = [#{'      '}
      'ssh-rsa #{test_key} vagrant',
      'command="/bin/echo Hello",from="myhost.example.com,192.168.1.1" ssh-rsa #{test_key} vagrant2',
      'ecdsa-sha2-nistp256 #{ecdsa_test_key} vagrant3',
      'sk-ecdsa-sha2-nistp256@openssh.com #{ecdsa_sk_test_key} vagrant4'
    ]
  }

  accounts::user { 'hunner':
    groups               => ['root'],
    password             => 'hi',
    shell                => '/bin/true',
    home                 => '/test/hunner',
    home_mode            => '0700',
    managevim            => false,
    bashrc_content       => file('accounts/shell/bashrc'),
    bash_profile_content => file('accounts/shell/bash_profile'),
    sshkeys              => $key_test,
  }
PUPPETCODE

pp_without_managehome = <<-PUPPETCODE
  accounts::user { 'hunner':
    managehome => false,
    sshkeys    => [
      'ssh-rsa #{test_key} vagrant',
    ],
  }
PUPPETCODE

pp_with_managevim = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['hunner'],
  }
  if $facts['puppetversion'][0] == '6' {
    $key_test = [
      'ssh-rsa #{test_key} vagrant',
      'command="/bin/echo Hello",from="myhost.example.com,192.168.1.1" ssh-rsa #{test_key} vagrant2'
    ]
  }
  else {
    $key_test = [#{'      '}
      'ssh-rsa #{test_key} vagrant',
      'command="/bin/echo Hello",from="myhost.example.com,192.168.1.1" ssh-rsa #{test_key} vagrant2',
      'ecdsa-sha2-nistp256 #{ecdsa_test_key} vagrant3',
      'sk-ecdsa-sha2-nistp256@openssh.com #{ecdsa_sk_test_key} vagrant4'
    ]
  }

  accounts::user { 'hunner':
    groups               => ['root'],
    password             => 'hi',
    shell                => '/bin/true',
    home                 => '/test/hunner',
    home_mode            => '0700',
    managevim            => true,
    bashrc_content       => file('accounts/shell/bashrc'),
    bash_profile_content => file('accounts/shell/bash_profile'),
    sshkeys              => $key_test,
  }
PUPPETCODE

pp_locked_user = <<-PUPPETCODE
  accounts::user { 'hunner':
    locked => true,
  }
PUPPETCODE

pp_custom_group_name = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['first.last'],
  }
  accounts::user { 'first.last':
    group                => 'staff',
    password             => '!!',
    home                 => '/test/first.last',
    home_mode            => '0700',
  }
PUPPETCODE

pp_create_group_false = <<-PUPPETCODE
  accounts::user { 'grp_flse':
    group                => 'newgrp_1',
    create_group         => false,
    home                 => '/test/grp_flse',
  }
PUPPETCODE

pp_create_group_true = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['grp_true'],
  }
  accounts::user { 'grp_true':
    group                => 'newgrp_2',
    create_group         => true,
    home                 => '/test/grp_true',
  }
PUPPETCODE

pp_ignore_user_first_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['ignore_user'],
  }
  accounts::user { 'ignore_user':
    group                    => 'staff',
    password                 => 'foo',
  }
PUPPETCODE

pp_ignore_user_second_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['ignore_user'],
  }
  accounts::user { 'ignore_user':
    group                    => 'staff',
    password                 => '',
    ignore_password_if_empty => true,
  }
PUPPETCODE

pp_no_ignore_user_first_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['no_ignore_user'],
  }
  accounts::user { 'no_ignore_user':
    group                    => 'staff',
    password                 => 'foo',
  }
PUPPETCODE

pp_no_ignore_user_second_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['no_ignore_user'],
  }
  accounts::user { 'no_ignore_user':
    group                    => 'staff',
    password                 => '',
    ignore_password_if_empty => false,
  }
PUPPETCODE

pp_specd_user_first_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['specd_user'],
  }
  accounts::user { 'specd_user':
    group                    => 'staff',
    password                 => 'foo',
  }
PUPPETCODE

pp_specd_user_second_run = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['specd_user'],
  }
  accounts::user { 'specd_user':
    group                    => 'staff',
    password                 => 'bar',
    ignore_password_if_empty => true,
  }
PUPPETCODE

pp_archive_homedir_before_user_deletion = <<-PUPPETCODE
  file { '/test/archives':
    ensure => 'directory',
    group  => 'archiver',
    mode   => '0700',
    owner  => 'archiver',
  }
  exec { 'backup homedir of specd_user':
    command => 'tar -czf /test/archives/specd_user.tar.gz specd_user',
    creates => '/test/specd_user.tar.gz',
    cwd     => '/home',
    path    => '/bin',
    require => File['/test/archives'],
  }
  accounts::user { 'specd_user':
    ensure          => 'absent',
    purge_user_home => true,
    require         => Exec['backup homedir of specd_user'],
  }
  accounts::user { 'archiver':
    ensure => 'present',
  }
PUPPETCODE

pp_user_with_duplicate_uid = <<-PUPPETCODE
  accounts::user { 'duplicate_user1':
    allowdupe    => true,
    uid          => '1234',
    sshkey_owner => 'duplicate_user1',
  }
  accounts::user { 'duplicate_user2':
    allowdupe    => true,
    uid          => '1234',
    sshkey_owner => 'duplicate_user1',
  }
PUPPETCODE

pp_user_with_sensitive_password = <<-PUPPETCODE
  accounts::user { 'sensitive_user':
    password => Sensitive('bar'),
  }
PUPPETCODE

pp_cleanup = <<-PUPPETCODE
  file { '/test':
    ensure  => 'absent',
    force   => true,
  }
PUPPETCODE

describe 'accounts::user define', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  after(:all) do
    # Cleanup any files created to ensure tests can be ran multiple times
    apply_manifest(pp_cleanup, catch_failures: true)
  end

  describe 'main tests' do
    it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles, managevim false' do
      apply_manifest(pp_accounts_define, catch_failures: true)

      expect(user('hunner')).to exist
      expect(user('hunner')).to belong_to_group 'hunner'
      expect(user('hunner')).to belong_to_group 'root'
      expect(user('hunner')).to have_login_shell '/bin/true'
      expect(user('hunner')).to have_home_directory '/test/hunner'
      expect(user('hunner')).to contain_password 'hi' unless os[:family] == 'solaris'

      expect(file('/test/hunner')).to be_directory
      expect(file('/test/hunner')).to be_mode 700
      expect(file('/test/hunner')).to be_owned_by 'hunner'
      expect(file('/test/hunner')).to be_grouped_into 'hunner'

      expect(file('/test/hunner/.bashrc')).to be_file
      expect(file('/test/hunner/.bashrc').content).to match %r{managed by Puppet}

      expect(file('/test/hunner/.bash_profile')).to be_file
      expect(file('/test/hunner/.bash_profile').content).to match %r{Get the aliases and functions}

      expect(file('/test/hunner/.vim')).not_to exist
    end
  end

  describe 'warn for sshkeys without managehome' do
    it 'creates groups of matching names, assigns non-matching group, manages homedir, manages other properties, gives key, makes dotfiles' do
      apply_manifest(pp_without_managehome, catch_failures: true) do |r|
        expect(r.stderr).to match(%r{Warning:.*ssh keys were passed for user hunner})
      end
    end
  end

  describe 'managevim set to true' do
    it '.vim file will be created' do
      apply_manifest(pp_with_managevim, catch_failures: true)
      expect(file('/test/hunner/.vim')).to be_directory
    end
  end

  describe 'locking users' do
    let(:login_shell) do
      case os[:family]
      when %r{debian|ubuntu} # Are there Debian-related distros besides Ubuntu?
        '/usr/sbin/nologin'
      when 'solaris'
        '/usr/bin/false'
      else
        '/sbin/nologin'
      end
    end

    it 'locks a user' do
      apply_manifest(pp_locked_user, catch_failures: true)
      expect(user('hunner')).to have_login_shell login_shell
    end
  end

  describe 'create user with custom group name' do
    it 'creates group of matching names, assigns non-matching group, manages homedir' do
      apply_manifest(pp_custom_group_name, catch_failures: true)

      expect(user('first.last')).to exist
      expect(user('first.last')).to belong_to_group 'staff'
      expect(user('first.last')).to have_home_directory '/test/first.last'

      expect(file('/test/first.last')).to be_directory
      expect(file('/test/first.last')).to be_mode 700
      expect(file('/test/first.last')).to be_owned_by 'first.last'
      expect(file('/test/first.last')).to be_grouped_into 'staff'
    end
  end

  describe 'group set to false does not create group' do
    it 'does not create group' do
      apply_manifest(pp_create_group_false, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{(.*group '?newgrp_1'? does not exist.*|.*Unknown group `?newgrp_1'?.*)})
      end

      expect(user('grp_flse')).not_to exist
      expect(user('grp_flse')).not_to belong_to_group 'new_group_1'
    end
  end

  describe 'group set to true creates group' do
    it 'creates group' do
      apply_manifest(pp_create_group_true, catch_failures: true)

      expect(user('grp_true')).to exist
      expect(user('grp_true')).to belong_to_group 'newgrp_2'
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'ignore password if ignore set to true', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group, empty password, ignore true, ignores password' do
      apply_manifest(pp_ignore_user_first_run, catch_failures: true)
      apply_manifest(pp_ignore_user_second_run, catch_failures: true)

      expect(user('ignore_user')).to exist
      expect(user('ignore_user')).to contain_password 'foo'
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'do not ignore password if ignore set to false', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group, empty password, ignore false, should not ignore password' do
      apply_manifest(pp_no_ignore_user_first_run, catch_failures: true)
      apply_manifest(pp_no_ignore_user_second_run, catch_failures: true)

      expect(user('no_ignore_user')).to exist
      expect(user('no_ignore_user')).to contain_password ''
    end
  end

  describe 'do not ignore password if set and ignore set to true', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group, specify password, ignore, should not ignore password' do
      apply_manifest(pp_specd_user_first_run, catch_failures: true)
      apply_manifest(pp_specd_user_second_run, catch_failures: true)

      expect(user('specd_user')).to exist
      expect(user('specd_user')).to contain_password 'bar'
    end
  end

  describe 'allow homedir archival before user deletion' do
    it 'allows creating one user before deleting another' do
      apply_manifest(pp_archive_homedir_before_user_deletion, catch_failures: true)

      expect(user('archiver')).to exist
      expect(user('specd_user')).not_to exist
      expect(file('/home/specd_user')).not_to exist
    end
  end

  describe 'create duplicate users with same uid' do
    it 'runs with no errors' do
      apply_manifest(pp_user_with_duplicate_uid, catch_failures: true)

      expect(user('duplicate_user1')).to exist
      expect(user('duplicate_user1')).to have_uid 1234

      expect(user('duplicate_user2')).to exist
      expect(user('duplicate_user2')).to have_uid 1234
    end
  end
  describe 'allow password to be a Sentitive type' do
    it 'runs with no errors' do
      apply_manifest(pp_user_with_sensitive_password, catch_failures: true)

      expect(user('sensitive_user')).to exist
      expect(user('sensitive_user')).to contain_password 'bar'
    end
  end
end
