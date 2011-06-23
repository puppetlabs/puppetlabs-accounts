# Class: accounts::users
#
#   This class manages user accounts defined in the data
#   namespace.
#
#   FIXME: Add more documentation.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
hostclass 'accounts::users' do
  # FIXME I can't pass parameters to Ruby DSL defined class.
  # As a result, I'm relying on the fact the accounts class sets
  # $users_hash in it's scope before declaring this class.

  # This is how we bring Puppet DSL variables into a local variable in the Ruby DSL
  # (Validation of these variables should already be done in the accounts class)
  users_hash         = scope.lookupvar('::accounts::users_hash')
  users_hash_default = scope.lookupvar('::accounts::users_hash_default')

  # First, pull out all of the user GID's and names and create a resource
  # for the primary group ID
  # As it might be expected, the resulting hash will contain the value returned
  # by a block for every key which exists in both hashes being merged:
  gid_hash = users_hash.merge(users_hash) do |title, param_hash|
    # v1 is the param
    param_hash.reject { |param, value| !%w{ ensure gid }.include?(param) }
  end
  # Add the before relationship to the User resource
  gid_hash.each do |title, param_hash|
    param_hash['before'] = "User[#{title}]"
  end

  # Now, add the group resources to the catalog:
  scope.function_create_resources(['group', gid_hash])
  # And the user resources
  scope.function_create_resources(['user', users_hash])

  # Manage the home directory
  users_hash.each do |title, param_hash|
    if param_hash.has_key?('home') then
      # JJM I'm not sure if it's best to call
      # the create_resources() function or declare the resource
      # directly from the DSL.
      file(param_hash['home'],
           :ensure => 'directory',
           :owner  => title,
           :group  => title,
           :mode   => '0700')
      # And some nice sub-directories
      %w{ .ssh .vim }.each do |subdir|
        file(File.join(param_hash['home'], subdir),
             :ensure => 'directory',
             :owner  => title,
             :group  => title,
             :mode   => '0700')
      end
    end
  end


end
