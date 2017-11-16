require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
UNSUPPORTED_PLATFORMS = %w[windows Darwin].freeze

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  c.formatter = :documentation
end

RSpec::Matchers.define :contain_password do |password|
  match do |user|
    if password == user.encrypted_password
      return true
    end
  end
  false
end
