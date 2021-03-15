# frozen_string_literal: true

require 'spec_helper'

describe 'Accounts::User::Name' do
  describe 'Valid user name values' do
    [
      '1-bad-dude',                       # Depending on the distribution, this might be an issue, however should be left to the distributions
      'a',
      '_',                                # Technically allowed but probably shouldn't be.
      'bravo',
      'charlie-99.Delta',                 # Can contain dashes, digits, dots and capitals.
      'ecHo123',
      'foxtrot$',                         # Can end in a dollar-sign
      '_golf_321_$',
      'supercalifragilisticexpialidocio', # 32 characters
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'Invalid user name values' do
    [
      '.hidden',                              # Cannot begin with a period.
      '$money',                               # Cannot begin with a dollar-sign.
      '-kilroy_was_here-',                    # Cannot begin with a dash.
      'more-$-and-cents',                     # Cannot have a dollar-sign in the middle.
      'fred.',                                # Cannot end in a period.
      'supercalifragilisticexpialiadocious',  # Too long: must be 1-32 chars.
      '',                                     # Cannot be empty.
      5,                                      # Or a non-string.
      {},
      [],
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
