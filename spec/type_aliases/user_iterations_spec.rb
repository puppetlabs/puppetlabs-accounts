# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Iterations' do
  describe 'Valid user iterations values' do
    [
      1,
      23,
      456,
      7890,
      '1',
      '23',
      '456',
      '7890',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user iterations values' do
    [
      0,
      -1,
      '02',
      '-3',
      'four',
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
