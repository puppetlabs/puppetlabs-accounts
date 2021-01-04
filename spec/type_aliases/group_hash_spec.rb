# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::Group::Hash' do
  describe 'Valid group hash values' do
    [
      { 'oldusers' => { 'ensure' => 'absent'  } },
      { 'sudoers'  => { 'system' => true      } },
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid group hash values' do
    [
      { '$$' => {}                                   },
      { '_a' => { 'ensure'          => false       } },
      { '_b' => { 'allowdupe'       => 'soitenly!' } },
      { '_c' => { 'auth_membership' => []          } },
      { '_d' => { 'forcelocal'      => {}          } },
      { '_e' => { 'gid'             => 'nine'      } },
      { '_f' => { 'members'         => [-1]        } },
      { '_g' => { 'provider'        => nil         } },
      { '_h' => { 'system'          => 'POSIX'     } },
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
