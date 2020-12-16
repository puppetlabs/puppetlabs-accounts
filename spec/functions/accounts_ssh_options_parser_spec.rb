# frozen_string_literal: true

require 'spec_helper'

describe 'accounts_ssh_options_parser' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params('').and_return([]) }
  it { is_expected.to run.with_params('"').and_raise_error(ArgumentError, %r{Unmatched double quote}) }
  it { is_expected.to run.with_params('tunnel="0"').and_return(['tunnel="0"']) }
  it { is_expected.to run.with_params('restrict,tunnel="0",command="sh /etc/netstart tun0"').and_return(['restrict', 'tunnel="0"', 'command="sh /etc/netstart tun0"']) }
end
