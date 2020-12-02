# frozen_string_literal: true

require 'spec_helper_acceptance'

test_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz'\
           '4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKL'\
           'v6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7P'\
           'tixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJ'\
           'nAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96h'\
           'rucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=='

hd_defaults = {
  'accounts::user_defaults' => {
    'home_mode' => '0700',
  },
}

hd_group = {
  'accounts::group_defaults' => {
    'ensure' => 'present',
    'system' => true,
  },
  'accounts::group_list' => {
    'staff' => {
      'gid' => 1234,
    },
  },
}

hd_group_change = hd_group.merge(
  'accounts::group_list' => {
    'staff' => {
      'gid' => 1235,
    },
  },
)

hd_accounts_define = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'groups'              => ['root'],
      'password'            => 'hi',
      'password_max_age'    => 60,
      'shell'               => '/bin/true',
      'home'                => '/test/hunner',
      'managevim'           => false,
      'bashrc_source'       => 'puppet:///modules/accounts/shell/bashrc',
      'bash_profile_source' => 'puppet:///modules/accounts/shell/bash_profile',
      'sshkeys'             => [
        "ssh-rsa #{test_key} vagrant",
        'command="/bin/echo Hello",from="myhost.exapmle.com,192.168.1.1" '\
        "ssh-rsa #{test_key} vagrant2",
      ],
    },
  },
)

hd_accounts_with_custom_key_path_define = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'sshkey_custom_path'  => '/test/sshkeys/hunner',
      'sshkey_owner'        => 'root',
      'sshkey_group'        => 'root',
      'groups'              => ['root'],
      'password'            => 'hi',
      'password_max_age'    => 60,
      'shell'               => '/bin/true',
      'home'                => '/test/hunner',
      'managevim'           => false,
      'bashrc_source'       => 'puppet:///modules/accounts/shell/bashrc',
      'bash_profile_source' => 'puppet:///modules/accounts/shell/bash_profile',
      'sshkeys'             => [
        "ssh-rsa #{test_key} vagrant",
        'command="/bin/echo Hello",from="myhost.exapmle.com,192.168.1.1" '\
        "ssh-rsa #{test_key} vagrant2",
      ],
    },
  },
)

hd_without_managehome = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'managehome' => false,
      'sshkeys'    => [
        "ssh-rsa #{test_key} vagrant",
      ],
    },
  },
)

hd_with_managevim = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'groups'              => ['root'],
      'password'            => 'hi',
      'shell'               => '/bin/true',
      'home'                => '/test/hunner',
      'home_mode'           => '0700',
      'managevim'           => true,
      'bashrc_source'       => 'puppet:///modules/accounts/shell/bashrc',
      'bash_profile_source' => 'puppet:///modules/accounts/shell/bash_profile',
      'sshkeys'             => [
        "ssh-rsa #{test_key} vagrant",
        'from="myhost.example.com,192.168.1.1" '\
        "ssh-rsa #{test_key} vagrant2",
      ],
    },
  },
)

hd_locked_user = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'locked' => true,
    },
  },
)

hd_custom_group_name = hd_defaults.merge(
  'accounts::user_list' => {
    'first.last' => {
      'group'    => 'staff',
      'password' => '!!',
      'home'     => '/test/first.last',
    },
  },
)

hd_create_group_false = hd_defaults.merge(
  'accounts::user_list' => {
    'grp_flse' => {
      'group'        => 'newgrp_1',
      'create_group' => false,
      'home'         => '/test/grp_flse',
    },
  },
)

hd_create_group_true = hd_defaults.merge(
  'accounts::user_list' => {
    'grp_true' => {
      'group'        => 'newgrp_2',
      'create_group' => true,
      'home'         => '/test/grp_true',
    },
  },
)

hd_ignore_user_first_run = hd_defaults.merge(
  'accounts::user_list' => {
    'ignore_user' => {
      'group'    => 'staff',
      'password' => 'foo',
    },
  },
)

hd_ignore_user_second_run = hd_defaults.merge(
  'accounts::user_list' => {
    'ignore_user' => {
      'group'                    => 'staff',
      'password'                 => '',
      'ignore_password_if_empty' => true,
    },
  },
)

hd_no_ignore_user_first_run = hd_defaults.merge(
  'accounts::user_list' => {
    'no_ignore_user' => {
      'group'    => 'staff',
      'password' => 'foo',
    },
  },
)

hd_no_ignore_user_second_run = hd_defaults.merge(
  'accounts::user_list' => {
    'no_ignore_user' => {
      'group'                    => 'staff',
      'password'                 => '',
      'ignore_password_if_empty' => false,
    },
  },
)

hd_specd_user_first_run = hd_defaults.merge(
  'accounts::user_list' => {
    'specd_user' => {
      'group'    => 'staff',
      'password' => 'foo',
    },
  },
)

hd_specd_user_second_run = hd_defaults.merge(
  'accounts::user_list' => {
    'specd_user' => {
      'group'                    => 'staff',
      'password'                 => 'bar',
      'ignore_password_if_empty' => true,
    },
  },
)

hd_user_with_duplicate_id = hd_defaults.merge(
  'accounts::user_list' => {
    'duplicate_user1' => {
      'allowdupe'    => true,
      'uid'          => '1234',
      'sshkey_owner' => 'duplicate_user1',
    },
    'duplicate_user2' => {
      'allowdupe'    => true,
      'uid'          => 1234,
      'sshkey_owner' => 'duplicate_user1',
    },
  },
)

hd_delete_accounts = {
  'accounts::group_defaults' => {
    'ensure' => 'absent',
  },
  'accounts::group_list' => {
    'newgrp_1' => {},
    'newgrp_2' => {},
    'staff'    => {},
  },
  'accounts::user_defaults' => {
    'ensure'          => 'absent',
    'create_group'    => true,
    'purge_user_home' => true,
  },
  'accounts::user_list' => {
    'hunner' => {
      'home'                => '/test/hunner',
      'sshkey_custom_path'  => '/test/sshkeys/hunner',
      'sshkey_owner'        => 'root',
      'sshkey_group'        => 'root',
      'sshkeys'             => [
        "ssh-rsa #{test_key} vagrant",
        "ssh-rsa #{test_key} vagrant2",
      ],
    },
    'first.last' => {
      'home'  => '/test/first.last',
    },
    'grp_flse' => {
      'home'  => '/test/grp_flse',
    },
    'grp_true' => {
      'home'  => '/test/grp_true',
    },
    'ignore_user' => {},
    'no_ignore_user' => {},
    'specd_user' => {},
    'duplicate_user1' => {},
    'duplicate_user2' => {},
  },
}

pp_manifest = <<-PUPPETCODE
  file { '/test':
    ensure => 'directory',
    before => Class['accounts'],
  }
  include ::accounts
PUPPETCODE

pp_manifest_custom_sshkey = <<-PUPPETCODE
  file { '/test':
    ensure => 'directory',
    before => Class['accounts'],
  }
  file { '/test/sshkeys':
    ensure => 'directory',
    before => Class['accounts'],
  }
  include ::accounts
PUPPETCODE

pp_cleanup = <<-PUPPETCODE
  include ::accounts
  file { '/test':
    ensure  => 'absent',
    force   => true,
  }
PUPPETCODE

describe 'accounts invoke', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  describe 'group test' do
    it 'creates group with specified gid' do
      set_hieradata(hd_group)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(group('staff')).to exist
      expect(group('staff')).to have_gid 1234
    end
    it 'changes existing group id' do
      set_hieradata(hd_group)
      apply_manifest(pp_manifest, catch_failures: true)
      set_hieradata(hd_group_change)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(group('staff')).to exist
      expect(group('staff')).to have_gid 1235
    end
  end

  describe 'main tests' do
    it 'creates groups of matching names, assigns non-matching group, '\
        'manages homedir, manages other properties, gives key, '\
        'makes dotfiles, managevim false' do
      set_hieradata(hd_accounts_define)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('hunner')).to exist
      expect(user('hunner')).to belong_to_group 'hunner'
      expect(user('hunner')).to belong_to_group 'root'
      expect(user('hunner')).to have_login_shell '/bin/true'
      expect(user('hunner')).to have_home_directory '/test/hunner'
      expect(user('hunner')).to contain_password 'hi' unless os[:family] == 'solaris'
      expect(user('hunner').maximum_days_between_password_change).to match 60

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

  describe 'main tests with custom key path' do
    it 'manages ssh key in a separate directory' do
      set_hieradata(hd_accounts_with_custom_key_path_define)
      apply_manifest(pp_manifest_custom_sshkey, catch_failures: true)

      expect(user('hunner')).to exist

      expect(file('/test/hunner')).to be_directory
      expect(file('/test/hunner')).to be_mode 700
      expect(file('/test/hunner')).to be_owned_by 'hunner'
      expect(file('/test/hunner')).to be_grouped_into 'hunner'

      expect(file('/test/hunner/.ssh/authorized_key')).not_to exist
      expect(file('/test/sshkeys/hunner')).to be_file
      expect(file('/test/sshkeys/hunner')).to be_owned_by 'root'
    end
  end

  describe 'warn for sshkeys without managehome' do
    it 'creates groups of matching names, assigns non-matching group, '\
        'manages homedir, manages other properties, gives key, '\
        'makes dotfiles' do
      set_hieradata(hd_without_managehome)
      apply_manifest(pp_manifest, catch_failures: true) do |r|
        expect(r.stderr).to match(%r{Warning:.*ssh keys were passed for user hunner})
      end
    end
  end

  describe 'managevim set to true' do
    it 'creates .vim file' do
      set_hieradata(hd_with_managevim)
      apply_manifest(pp_manifest, catch_failures: true)
      expect(file('/test/hunner/.vim')).to be_directory
    end
  end

  describe 'locking users' do
    let(:login_shell) do
      case os[:family]
      when %r{debian|ubuntu}
        '/usr/sbin/nologin'
      when 'solaris'
        '/usr/bin/false'
      else
        '/sbin/nologin'
      end
    end

    it 'locks a user' do
      set_hieradata(hd_locked_user)
      apply_manifest(pp_manifest, catch_failures: true)
      expect(user('hunner')).to have_login_shell login_shell
    end
  end

  describe 'create user with custom group name' do
    it 'creates group of matching names, assigns non-matching group, '\
        'manages homedir' do
      set_hieradata(hd_custom_group_name)
      apply_manifest(pp_manifest, catch_failures: true)

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
      set_hieradata(hd_create_group_false)
      apply_manifest(pp_manifest, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{(.*group '?newgrp_1'? does not exist.*|.*Unknown group `?newgrp_1'?.*)})
      end
      expect(user('grp_flse')).not_to exist
      expect(user('grp_flse')).not_to belong_to_group 'new_group_1'
    end
  end

  describe 'group set to true creates group' do
    it 'creates group' do
      set_hieradata(hd_create_group_true)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('grp_true')).to exist
      expect(user('grp_true')).to belong_to_group 'newgrp_2'
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'ignore password if ignore set to true', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group,'\
        'empty password, ignore true, ignores password' do
      set_hieradata(hd_ignore_user_first_run)
      apply_manifest(pp_manifest, catch_failures: true)
      set_hieradata(hd_ignore_user_second_run)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('ignore_user')).to exist
      expect(user('ignore_user')).to contain_password 'foo'
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'do not ignore password if ignore set to false', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group,'\
        'empty password, ignore false, should not ignore password' do
      set_hieradata(hd_no_ignore_user_first_run)
      apply_manifest(pp_manifest, catch_failures: true)
      set_hieradata(hd_no_ignore_user_second_run)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('no_ignore_user')).to exist
      expect(user('no_ignore_user')).to contain_password ''
    end
  end

  describe 'do not ignore password if set and ignore set to true', unless: os[:family] == 'solaris' do
    it 'creates group of matching names, assigns non-matching group, '\
        'specify password, ignore, should not ignore password' do
      set_hieradata(hd_specd_user_first_run)
      apply_manifest(pp_manifest, catch_failures: true)
      set_hieradata(hd_specd_user_second_run)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('specd_user')).to exist
      expect(user('specd_user')).to contain_password 'bar'
    end
  end

  describe 'create duplicate users with same uid' do
    it 'runs with no errors' do
      set_hieradata(hd_user_with_duplicate_id)
      apply_manifest(pp_manifest, catch_failures: true)

      expect(user('duplicate_user1')).to exist
      expect(user('duplicate_user1')).to have_uid 1234

      expect(user('duplicate_user2')).to exist
      expect(user('duplicate_user2')).to have_uid 1234
    end
  end

  describe 'delete accounts' do
    it 'removes users and groups' do
      set_hieradata(hd_delete_accounts)
      apply_manifest(pp_cleanup, catch_failures: true)

      expect(file('/test')).not_to exist
      expect(file('/home/ignore_user')).not_to exist
      expect(file('/home/no_ignore_user')).not_to exist
      expect(file('/home/specd_user')).not_to exist
      expect(file('/home/duplicate_user1')).not_to exist
      expect(file('/home/duplicate_user2')).not_to exist
      expect(file('/test/sshkeys/hunner')).not_to exist
      expect(user('hunner')).not_to exist
      expect(user('first.last')).not_to exist
      expect(user('grp_flse')).not_to exist
      expect(user('grp_true')).not_to exist
      expect(user('ignore_user')).not_to exist
      expect(user('no_ignore_user')).not_to exist
      expect(user('specd_user')).not_to exist
      expect(user('duplicate_user1')).not_to exist
      expect(user('duplicate_user2')).not_to exist
      expect(group('staff')).not_to exist
      expect(group('hunner')).not_to exist
      expect(group('newgrp_1')).not_to exist
      expect(group('newgrp_2')).not_to exist
      expect(group('duplicate_user1')).not_to exist
      expect(group('duplicate_user2')).not_to exist
    end
  end
end
