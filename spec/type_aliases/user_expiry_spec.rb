# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Expiry' do
  describe 'Valid user expiry values' do
    [
      'absent',
      '1901-01-01',
      '1992-02-04',
      '2183-03-06',
      '3274-04-09',
      '3365-05-12',
      '4456-06-15',
      '5547-07-17',
      '6638-08-20',
      '7729-09-22',
      '8820-10-25',
      '9911-11-27',
      '9999-12-31',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user expiry values' do
    [
      'present',
      '0001-01-01',
      '0010-01-01',
      '0100-01-01',
      '1000-01-01',
      '1899-01-01',
      '1900-00-01',
      '2000-13-01',
      '2100-01-00',
      '2100-01-00',
      '2200-01-32',
      '....-..-..',
      '1999.01.01',
      '--',
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
