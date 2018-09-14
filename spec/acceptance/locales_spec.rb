require 'spec_helper_acceptance'
require 'beaker/i18n_helper'

test_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8Hfd'\
           'OV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9W'\
           'hQ=='

pp_accounts_key_definition = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['hunner'],
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
    sshkeys              => [
      '"',
    ],
  }
  PUPPETCODE

pp_accounts_ssh_warn = <<-PUPPETCODE
  file { '/test':
    ensure => directory,
    before => Accounts::User['hunner'],
  }
  accounts::user { 'hunner':
    groups               => ['root'],
    password             => 'hi',
    shell                => '/bin/true',
    home                 => '/test/hunner',
    home_mode            => '0700',
    managehome => false,
    managevim            => false,
    sshkeys              => [
      'ssh-rsa #{test_key} vagrant',
    ],
  }
PUPPETCODE

describe 'accounts::user define', if: (fact('osfamily') == 'Debian' || fact('osfamily') == 'RedHat') && (Gem::Version.new(puppet_version) >= Gem::Version.new('4.10.5')) do
  before :all do
    hosts.each do |host|
      on(host, "sed -i \"96i FastGettext.locale='ja'\" /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb")
      change_locale_on(host, 'ja_JP.utf-8')
    end
  end

  describe 'i18n translations' do
    it 'When triggering error for uninterpretable key definition' do
      apply_manifest(pp_accounts_key_definition, catch_failures: true) do |r|
        expect(r.stderr).to match(%r{SSHキーの定義が解釈できませんでした})
      end
    end
    it 'When triggering warning for sshkeys without managehome' do
      apply_manifest(pp_accounts_ssh_warn, catch_failures: true) do |r|
        expect(r.stderr).to match(%r{SSHキーがユーザhunnerに対して渡されましたが})
      end
    end
  end

  after :all do
    hosts.each do |host|
      on(host, 'sed -i "96d" /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb')
      change_locale_on(host, 'en_US')
    end
  end
end
