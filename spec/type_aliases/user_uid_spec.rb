# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Uid' do
  describe 'Valid user uid values' do
    [
      0,
      12,
      345,
      6789,
      78_901,
      890_123,
      999_999_999,
      '1000000001',
      '2000000002',
      '3999999999',
      '4199999999',
      '4289999999',
      '4293999999',
      '4294899999',
      '4294966999',
      '4294967199',
      '4294967289',
      '4294967295',
      2**32 - 1,
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user uid values' do
    [
      -1,
      '-1',
      2**32,
      '4294967296',
      '007',
      '',
      {},
      [],
      nil,
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
