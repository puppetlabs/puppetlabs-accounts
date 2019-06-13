# frozen_string_literal: true

require 'bolt_spec/run'
require 'puppet_litmus/inventory_manipulation'

UNSUPPORTED_PLATFORMS = ['windows', 'darwin'].freeze

# rubocop:disable all
#####################################################################################
# Partially copied from simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
# Original copyright therefrom applies.                                             #
#####################################################################################

# A shim to stand in for the now deprecated hiera_datadir function
#
# Note: This may not work if you've shoved data somewhere that is not the
# default and/or are manipulating the default hiera.yaml.
#
# @returns [String] Path to the Hieradata directory on the target system
def hiera_datadir
  # This output lets us know where Hiera is configured to look on the system
  puppet_lookup_info = run_shell('puppet lookup --explain test__simp__test').stdout.strip.lines
  puppet_config_check = run_shell('puppet agent --configprint manifest').stdout

  if puppet_config_check.nil? || puppet_config_check.empty?
    fail("No output returned from `puppet config print manifest`")
  end

  puppet_env_path = File.dirname(puppet_config_check)

  # We'll just take the first match since Hiera will find things there
  puppet_lookup_info = puppet_lookup_info.grep(/Path "/).grep(Regexp.new(puppet_env_path))

  # Grep always returns an Array
  if puppet_lookup_info.empty?
    fail("Could not determine hiera data directory under #{puppet_env_path}")
  end

  # Snag the actual path without the extra bits
  puppet_lookup_info = puppet_lookup_info.first.strip.split('"').last

  # Make the parent directories exist
  run_shell("mkdir -p #{File.dirname(puppet_lookup_info)}", acceptable_exit_codes: [0])

  # We just want the data directory name
  datadir_name = puppet_lookup_info.split(puppet_env_path).last

  # Grab the file separator to add back later
  file_sep = datadir_name[0]

  # Snag the first entry (this is the data directory)
  datadir_name = datadir_name.split(file_sep)[1]

  # Constitute the full path to the data directory
  datadir_path = puppet_env_path + file_sep + datadir_name

  # Return the path to the data directory
  return datadir_path
end

# Write the provided data structure to Hiera's :datadir and configure Hiera to
# use that data exclusively.
#
# @note This is authoritative.  It manages both Hiera data and configuration,
#   so it may not be used with other Hiera data sources.
#
# @param hieradata [Hash, String] The full hiera data structure to write to
#   the system.
#
# @return [Nil]
#
def set_hieradata(hieradata)
  @temp_hieradata_dirs ||= []
  data_dir = Dir.mktmpdir('hieradata')
  @temp_hieradata_dirs << data_dir

  fh = File.open(File.join(data_dir, 'common.yaml'), 'w')
  if hieradata.is_a?(String)
    fh.puts(hieradata)
  else
    fh.puts(hieradata.to_yaml)
  end
  fh.close

  run_shell("mkdir -p #{File.dirname(data_dir)}", acceptable_exit_codes: [0])
  result = upload_file(File.join(data_dir, 'common.yaml'), File.join(@hiera_datadir, 'common.yaml'), ENV['TARGET_HOST'], options: {}, config: nil, inventory: inventory_hash_from_inventory_file)
  raise "error uploading hiera file to #{ENV['TARGET_HOST']}" if result[0]["status"] !~ %r{success}
end

# Clean up all temporary hiera data files.
#
# Meant to be called from after(:all)
def clear_temp_hieradata
  if @temp_hieradata_dirs && !@temp_hieradata_dirs.empty?
    @temp_hieradata_dirs.each do |data_dir|
      if File.exists?(data_dir)
        FileUtils.rm_r(data_dir)
      end
    end
  end
end

RSpec.configure do |c|
  c.before(:all) do
    @temp_hieradata_dirs = @temp_hieradata_dirs || []
    @hiera_datadir = hiera_datadir
  end

  c.after(:all) do
    clear_temp_hieradata
  end

  c.formatter = :documentation
end

###########################################################################
# End copying simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
###########################################################################
# rubocop:enable all

RSpec::Matchers.define :contain_password do |password|
  match do |user|
    if password == user.encrypted_password
      return true
    end
  end
  false
end
