# frozen_string_literal: true

require 'spec_helper'

describe 'accounts_ssh_authorized_keys_line_parser' do
  it {
    expect(subject).not_to be_nil
  }

  it {
    expect(subject).to run.with_params('').and_raise_error(ArgumentError, %r{'accounts_ssh_authorized_keys_line_parser' parameter 'str' expects a String\[1\] value, got String})
  }

  it {
    expect(subject).to run.with_params('options unknown-keytype key comment').and_raise_error(ArgumentError, %r{Wrong Keyline format!})
  }

  it {
    expect(subject).to run.with_params('ssh-xyz key name with spaces').and_return( \
      ['', 'ssh-xyz', 'key', 'name with spaces'],
    )
  }

  it {
    expect(subject).to run.with_params('"options with arguments",moreoptions,"moreoptions with arguments" ecdsa-xyz key name with spaces').and_return( \
      ['"options with arguments",moreoptions,"moreoptions with arguments"', 'ecdsa-xyz', 'key', 'name with spaces'],
    )
  }

  it {
    expect(subject).to run.with_params('tunnel="0",command="sh /etc/netstart tun0" ssh-rsa AAAA...== jane@example.net').and_return( \
      ['tunnel="0",command="sh /etc/netstart tun0"', 'ssh-rsa', 'AAAA...==', 'jane@example.net'],
    )
  }

  it {
    # rubocop:disable Layout/LineLength
    expect(subject).to run.with_params('command="rsync --server --sender -vlHogtpr --numeric-ids . /",from="192.168.1.1",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ecdsa-sha2-nistp384 AAAA...= rsync backup').and_return( \
      ['command="rsync --server --sender -vlHogtpr --numeric-ids . /",from="192.168.1.1",no-port-forwarding,no-X11-forwarding,no-agent-forwarding', 'ecdsa-sha2-nistp384', 'AAAA...=', 'rsync backup'],
    )
    # rubocop:enable Layout/LineLength
  }
end
