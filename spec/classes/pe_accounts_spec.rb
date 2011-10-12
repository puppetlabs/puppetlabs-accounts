require 'spec_helper'
require 'classes/shared'

describe 'pe_accounts' do
  let(:params) { {} }
  let(:facts) { {} }
  let(:contain_file_line_sudo_rules) { create_resource('file_line', 'sudo_rules') }
  let(:contain_file_line_sudonopw_rules) { create_resource('file_line', 'sudonopw_rules') }

  describe "when setting pe_accounts params" do

    # This parameter hash provides valid and invalid values for automatic
    # test generated. See 'classes/shared.rb' for details.
    parameters = {
      :manage_groups => {
        :valid   => [ true, false ],
        :invalid => [ nil, 'true', 'false', 'yes', 'no', '' ],
      },
      :manage_users => {
        :valid   => [ true, false ],
        :invalid => [ nil, 'true', 'false', 'yes', 'no', '' ],
      },
      :manage_sudoers => {
        :valid   => [ true, false ],
        :invalid => [ nil, 'true', 'false', 'yes', 'no', '' ],
      },
      # We can't support 'yaml' here because the class will try to load
      # Puppet[:confdir]/data/pe_accounts_users_hash.yaml
      :data_store => {
        :valid => [ 'namespace' ],
        :invalid => [ '', nil, true, false, 'somethingelse' ],
      },
      # We have to make sure the classes exist for the "valid" section
      # Therefore, while site::pe_accounts::data is valid, it won't be
      # unless the class is defined.  There should be a separate test
      # for this as a result.
      :data_namespace => {
        :valid   => [ 'pe_accounts::data' ],
        :invalid => [ 'site::pe_accounts', '', false, nil, 'site' ],
      },
      :sudoers_path => {
        :valid => [ '/etc/sudoers', '/etc/opt/csw/sudoers' ],
        :invalid => [ 'etc/sudoers', '', true, nil, '/etc/sudoers/' ],
      }

    }

    # Call shared example
    it_should_behave_like 'a parameterized class', 'pe_accounts', parameters

    # Convenience helper for returning parameters for a type from the
    # catalogue.
    def param(type, title, param)
      catalogue.resource(type, title).send(:parameters)[param.to_sym]
    end
  end

  # Make sure we don't touch sudoers by default.
  describe "when using default class parameters" do
    it { should_not contain_file_line_sudo_rules }
    it { should_not contain_file_line_sudonopw_rules }
  end
  # Make sure we manage sudoers if told to do so
  describe "when manage_sudoers is true" do
    before :each do
      params['manage_sudoers'] = true
    end
    it { should contain_file_line_sudo_rules.with_param('path', '/etc/sudoers') }
    it { should contain_file_line_sudonopw_rules.with_param('path', '/etc/sudoers') }

    # We shouldn't manage sudoers on Solaris
    describe "on Solaris" do
      before :each do
        facts['operatingsystem'] = 'Solaris'
      end
      it { should_not contain_file_line_sudo_rules }
      it { should_not contain_file_line_sudonopw_rules }
    end
  end

  describe "class containment (Anchor Points)" do
    it { should create_resource('anchor', 'pe_accounts::begin') }
    it { should create_resource('anchor', 'pe_accounts::end') }
  end

end

