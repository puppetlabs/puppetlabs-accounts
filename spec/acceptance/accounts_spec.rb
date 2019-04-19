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
    'staff'    => {
      'gid'    => 1234,
    },
  },
}

hd_accounts_define = hd_defaults.merge(
  'accounts::user_list' => {
    'hunner' => {
      'groups'              => ['root'],
      'password'            => 'hi',
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
        "ssh-rsa #{test_key}} vagrant",
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
    'cuser' => {
      'group'     => 'staff',
      'password'  => '!!',
      'home'      => '/test/cuser',
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

pp_manifest = <<-PUPPETCODE
  file { '/test':
    ensure => 'directory',
    before => Class['accounts'],
  }
  include ::accounts
PUPPETCODE

pp_cleanup = <<-PUPPETCODE
  $files = [
    '/test',
    '/home/hunner',
    '/home/ignore_user',
    '/home/no_ignore_user',
    '/home/specd_user',
    '/home/duplicate_user1',
    '/home/duplicate_user2',
  ]
  $file_params = {
    'ensure' => 'absent',
    'force'  => true,
  }
  ensure_resource('file', $files, $file_params)
  $users = [
    'hunner',
    'cuser',
    'grp_flse',
    'grp_true',
    'ignore_user',
    'no_ignore_user',
    'specd_user',
    'duplicate_user1',
    'duplicate_user2',
  ]
  $user_params =     {
    'ensure'  => 'absent',
    'require' => File[$files],
  }
  ensure_resource('user', $users, $user_params)
  $groups = [
    'staff',
    'hunner',
    'newgrp_1',
    'newgrp_2',
    'duplicate_user1',
    'duplicate_user2',
  ]
  $group_params =     {
    'ensure'  => 'absent',
    'require' => User[$users],
  }
  ensure_resource('group', $groups, $group_params)
PUPPETCODE

describe 'accounts invoke', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  describe 'group test' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group with specified gid' do
          set_hieradata_on(host, hd_group)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(group('staff')).to exist
          expect(group('staff')).to have_gid 1234
        end
      end
    end
  end

  describe 'main tests' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates groups of matching names, assigns non-matching group, '\
           'manages homedir, manages other properties, gives key, '\
           'makes dotfiles, managevim false' do
          set_hieradata_on(host, hd_accounts_define)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('hunner')).to exist
          expect(user('hunner')).to belong_to_group 'hunner'
          expect(user('hunner')).to belong_to_group 'root'
          expect(user('hunner')).to have_login_shell '/bin/true'
          expect(user('hunner')).to have_home_directory '/test/hunner'
          expect(user('hunner')).to contain_password 'hi' unless os[:family] =~ %r{solaris}

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
    end
  end

  describe 'warn for sshkeys without managehome' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates groups of matching names, assigns non-matching group, '\
           'manages homedir, manages other properties, gives key, '\
           'makes dotfiles' do
          set_hieradata_on(host, hd_without_managehome)
          apply_manifest_on(host, pp_manifest, catch_failures: true) do |r|
            expect(r.stderr).to match(%r{Warning:.*ssh keys were passed for user hunner})
          end
        end
      end
    end
  end

  describe 'managevim set to true' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates .vim file' do
          set_hieradata_on(host, hd_with_managevim)
          apply_manifest_on(host, pp_manifest, catch_failures: true)
          expect(file('/test/hunner/.vim')).to be_directory
        end
      end
    end
  end

  describe 'locking users' do
    let(:login_shell) do
      case os[:family]
      when 'debian'
        '/usr/sbin/nologin'
      when 'ubuntu'
        '/usr/sbin/nologin'
      when 'solaris'
        '/usr/bin/false'
      else
        '/sbin/nologin'
      end
    end

    hosts.each do |host|
      context "on #{host}" do
        it 'locks a user' do
          set_hieradata_on(host, hd_locked_user)
          apply_manifest_on(host, pp_manifest, catch_failures: true)
          expect(user('hunner')).to have_login_shell login_shell
        end
      end
    end
  end

  describe 'create user with custom group name' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group of matching names, assigns non-matching group, '\
           'manages homedir' do
          set_hieradata_on(host, hd_custom_group_name)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('cuser')).to exist
          expect(user('cuser')).to belong_to_group 'staff'
          expect(user('cuser')).to have_home_directory '/test/cuser'

          expect(file('/test/cuser')).to be_directory
          expect(file('/test/cuser')).to be_mode 700
          expect(file('/test/cuser')).to be_owned_by 'cuser'
          expect(file('/test/cuser')).to be_grouped_into 'staff'
        end
      end
    end
  end

  describe 'group set to false does not create group' do
    hosts.each do |host|
      context "on #{host}" do
        it 'does not create group' do
          set_hieradata_on(host, hd_create_group_false)
          apply_manifest_on(host, pp_manifest, expect_failures: true) do |r|
            expect(r.stderr).to match(%r{(.*group '?newgrp_1'? does not exist.*|.*Unknown group `?newgrp_1'?.*)})
          end
          expect(user('grp_flse')).not_to exist
          expect(user('grp_flse')).not_to belong_to_group 'new_group_1'
        end
      end
    end
  end

  describe 'group set to true creates group' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group' do
          set_hieradata_on(host, hd_create_group_true)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('grp_true')).to exist
          expect(user('grp_true')).to belong_to_group 'newgrp_2'
        end
      end
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'ignore password if ignore set to true',
           unless: os[:family] == 'solaris' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group of matching names, assigns non-matching group,'\
           'empty password, ignore true, ignores password' do
          set_hieradata_on(host, hd_ignore_user_first_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)
          set_hieradata_on(host, hd_ignore_user_second_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('ignore_user')).to exist
          expect(user('ignore_user')).to contain_password 'foo'
        end
      end
    end
  end

  # Solaris does not offer a means of testing the password
  describe 'do not ignore password if ignore set to false',
           unless: os[:family] == 'solaris' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group of matching names, assigns non-matching group,'\
           'empty password, ignore false, should not ignore password' do
          set_hieradata_on(host, hd_no_ignore_user_first_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)
          set_hieradata_on(host, hd_no_ignore_user_second_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('no_ignore_user')).to exist
          expect(user('no_ignore_user')).to contain_password ''
        end
      end
    end
  end

  describe 'do not ignore password if set and ignore set to true', unless: os[:family] == 'solaris' do
    hosts.each do |host|
      context "on #{host}" do
        it 'creates group of matching names, assigns non-matching group, '\
            'specify password, ignore, should not ignore password' do
          set_hieradata_on(host, hd_specd_user_first_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)
          set_hieradata_on(host, hd_specd_user_second_run)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('specd_user')).to exist
          expect(user('specd_user')).to contain_password 'bar'
        end
      end
    end
  end

  describe 'create duplicate users with same uid' do
    hosts.each do |host|
      context "on #{host}" do
        it 'runs with no errors' do
          set_hieradata_on(host, hd_user_with_duplicate_id)
          apply_manifest_on(host, pp_manifest, catch_failures: true)

          expect(user('duplicate_user1')).to exist
          expect(user('duplicate_user1')).to have_uid 1234

          expect(user('duplicate_user2')).to exist
          expect(user('duplicate_user2')).to have_uid 1234
        end
      end
    end
  end

  describe 'cleanup' do
    hosts.each do |host|
      context "on #{host}" do
        it 'removes users and groups' do
          set_hieradata_on(host, {})
          apply_manifest_on(host, pp_cleanup, catch_failures: true)

          expect(file('/test')).not_to exist
          expect(file('/home/hunner')).not_to exist
          expect(file('/home/ignore_user')).not_to exist
          expect(file('/home/no_ignore_user')).not_to exist
          expect(file('/home/specd_user')).not_to exist
          expect(file('/home/duplicate_user1')).not_to exist
          expect(file('/home/duplicate_user2')).not_to exist
          expect(user('hunner')).not_to exist
          expect(user('cuser')).not_to exist
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
  end
end
