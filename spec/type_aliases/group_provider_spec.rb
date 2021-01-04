# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::Group::Provider' do
  describe 'Valid group provider values' do
    [
      'aix',
      'directoryservice',
      'groupadd',
      'ldap',
      'pw',
      'windows_adsi',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid group provider values' do
    [
      0,
      false,
      'GroupAdd',
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
