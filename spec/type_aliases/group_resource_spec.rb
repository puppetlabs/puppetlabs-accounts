# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::Group::Resource' do
  describe 'Valid group resource values' do
    [
      {},
      { 'ensure'                   => 'absent'                     },
      { 'allowdupe'                => false                        },
      { 'auth_membership'          => true                         },
      { 'forcelocal'               => false                        },
      { 'gid'                      => 999                          },
      { 'members'                  => ['root']                     },
      { 'name'                     => 'root'                       },
      { 'provider'                 => 'pw'                         },
      { 'system'                   => false                        },
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid group resource values' do
    [
      { 'bogus'                    => true                         },
      { 'ensure'                   => false                        },
      { 'allowdupe'                => 'soitenly!'                  },
      { 'auth_membership'          => 'no'                         },
      { 'forcelocal'               => -1                           },
      { 'gid'                      => 'nine'                       },
      { 'members'                  => [-1]                         },
      { 'name'                     => '$invalid'                   },
      { 'provider'                 => 'Custom'                     },
      { 'system'                   => 'Linux'                      },
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
