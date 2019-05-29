require 'beaker-pe'
require 'beaker-puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker/i18n_helper'
require 'beaker-task_helper'

UNSUPPORTED_PLATFORMS = ['windows', 'darwin'].freeze

run_puppet_install_helper
configure_type_defaults_on(hosts)
install_module_on(hosts)
install_module_dependencies_on(hosts)

# rubocop:disable all
###########################################################################
# Copied from simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
# Original copyright therefrom applies.                                   #
###########################################################################

# We can't cache this because it may change during a run
def fips_enabled(sut)
  return on( sut,
            'cat /proc/sys/crypto/fips_enabled 2>/dev/null',
            :accept_all_exit_codes => true
           ).output.strip == '1'
end

# Figure out the best method to copy files to a host and use it
#
# Will create the directories leading up to the target if they don't exist
def copy_to(sut, src, dest, opts={})
  unless fips_enabled(sut) || @has_rsync
    %x{which rsync 2>/dev/null}.strip

    @has_rsync = !$?.nil? && $?.success?
  end

  sut.mkdir_p(File.dirname(dest))

  if sut[:hypervisor] == 'docker'
    exclude_list = []
    if opts.has_key?(:ignore) && !opts[:ignore].empty?
      opts[:ignore].each do |value|
        exclude_list << "--exclude '#{value}'"
      end
    end

    # Work around for breaking changes in beaker-docker
    if sut.host_hash[:docker_container]
      container_id = sut.host_hash[:docker_container].id
    else
      container_id = sut.host_hash[:docker_container_id]
    end
    %x(tar #{exclude_list.join(' ')} -hcf - -C "#{File.dirname(src)}" "#{File.basename(src)}" | docker exec -i "#{container_id}" tar -C "#{dest}" -xf -)
  elsif @has_rsync && sut.check_for_command('rsync')
    # This makes rsync_to work like beaker and scp usually do
    exclude_hack = %(__-__' -L --exclude '__-__)

    # There appears to be a single copy of 'opts' that gets passed around
    # through all of the different hosts so we're going to make a local deep
    # copy so that we don't destroy the world accidentally.
    _opts = Marshal.load(Marshal.dump(opts))
    _opts[:ignore] ||= []
    _opts[:ignore] << exclude_hack

    if File.directory?(src)
      dest = File.join(dest, File.basename(src)) if File.directory?(src)
      sut.mkdir_p(dest)
    end

    # End rsync hackery

    begin
      rsync_to(sut, src, dest, _opts)
    rescue
      # Depending on what is getting tested, a new SSH session might not
      # work. In this case, we fall back to SSH.
      #
      # The rsync failure is quite fast so this doesn't affect performance as
      # much as shoving a bunch of data over the ssh session.
      scp_to(sut, src, dest, opts)
    end
  else
    scp_to(sut, src, dest, opts)
  end
end

## Inline Hiera Helpers ##
## These will be integrated into core Beaker at some point ##

j###########################################################################
# Moved before(:all) / after(:all) code to main Rspec.configure loop.     #
###########################################################################

# Writes a YAML file in the Hiera :datadir of a Beaker::Host.
#
# @note This is useless unless Hiera is configured to use the data file.
#   @see `#write_hiera_config_on`
#
# @param sut  [Array<Host>, String, Symbol] One or more hosts to act upon.
#
# @param hieradata [Hash, String] The full hiera data structure to write to
#   the system.
#
# @return [Nil]
#
# @note This creates a tempdir on the host machine which should be removed
#   using `#clear_temp_hieradata` in the `after(:all)` hook.  It may also be
#   retained for debugging purposes.
#
def write_hieradata_to(sut, hieradata)
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

  copy_hiera_data_to sut, File.join(data_dir, 'common.yaml')
end

# A shim to stand in for the now deprecated copy_hiera_data_to function
#
# @param sut [Host]  One host to act upon
#
# @param [Path] File containing hiera data
def copy_hiera_data_to(sut, path)
  copy_to(sut, path, hiera_datadir(sut))
end

# A shim to stand in for the now deprecated hiera_datadir function
#
# Note: This may not work if you've shoved data somewhere that is not the
# default and/or are manipulating the default hiera.yaml.
#
# @param sut  [Host] One host to act upon
#
# @returns [String] Path to the Hieradata directory on the target system
def hiera_datadir(sut)
  # This output lets us know where Hiera is configured to look on the system
  puppet_lookup_info = on(sut, 'puppet lookup --explain test__simp__test').output.strip.lines

  if sut.puppet['manifest'].nil? || sut.puppet['manifest'].empty?
    fail("No output returned from `puppet config print manifest` on #{sut}")
  end

  puppet_env_path = File.dirname(sut.puppet['manifest'])

  # We'll just take the first match since Hiera will find things there
  puppet_lookup_info = puppet_lookup_info.grep(/Path "/).grep(Regexp.new(puppet_env_path))

  # Grep always returns an Array
  if puppet_lookup_info.empty?
    fail("Could not determine hiera data directory under #{puppet_env_path} on #{sut}")
  end

  # Snag the actual path without the extra bits
  puppet_lookup_info = puppet_lookup_info.first.strip.split('"').last

  # Make the parent directories exist
  sut.mkdir_p(File.dirname(puppet_lookup_info))

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
# @param sut  [Array<Host>, String, Symbol] One or more hosts to act upon.
#
# @param heradata [Hash, String] The full hiera data structure to write to
#   the system.
#
# @return [Nil]
#
def set_hieradata_on(sut, hieradata)
  write_hieradata_to sut, hieradata
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
###########################################################################
# End copying simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
###########################################################################
# rubocop:enable all

RSpec.configure do |c|
  # rubocop:disable all
  ###########################################################################
  # Copied from simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
  # Original copyright therefrom applies.                                   #
  ###########################################################################
  c.before(:all) do
    @temp_hieradata_dirs = @temp_hieradata_dirs || []
  end

  # We can't guarantee that the upstream vendor isn't disabling interfaces so
  # we need to turn them on at each context run
  # c.before(:context) do
  #  activate_interfaces(hosts) unless ENV['BEAKER_no_fix_interfaces']
  # end

  c.after(:all) do
    clear_temp_hieradata
  end
  ###########################################################################
  # End copying simp/rubygem-simp-beaker-helpers/lib/simp/beaker_helpers.rb #
  ###########################################################################
  # rubocop:enable all

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
