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

  # We need this list to filter out keys from the resource hashes we're dealing with.
  valid_metaparams = %w{ require before subscribe notify tag }

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

  # Filter the users_hash, rejecting anything not usable by the
  # native user type.
  # JJM Deliberately ignoring Solaris RBAC and Profile stuff
  # JJM FIXME: Possibly add the account aging parameters?
  valid_user_params = %w{ ensure home shell comment password uid
    gid manage_home provider name managehome groups expiry } << valid_metaparams
  users_rsrc_hash = users_hash.merge(users_hash) do |title, param_hash|
    # merge in the defaults specified by the user
    param_hash = users_hash_default.merge(param_hash)
    # Strip out all 2nd level keys that aren't valid for the user type
    param_hash.reject! { |param, value| !valid_user_params.include?(param) }
    # FIXME Interpolate all string values (This may be a HORRIBLE idea)
    # It may be better to ONLY interpolate the home directory or something
    if param_hash.has_key?('home') then
      param_hash['home'] = eval('"' << param_hash['home'] << '"')
    end
    param_hash
  end
  # Create the user resources
  scope.function_create_resources(['user', users_rsrc_hash])

  # Manage the home directory from the filtered user resources hash
  users_rsrc_hash.each do |title, param_hash|
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
      # Check for sshkeys in the user supplied hash.  We do this because this
      # key will be stripped out when merging keys for use with create_resources()
      if users_hash[title].has_key?('sshkeys') then
        # We expect this to be an user-defined array of keys that have simply been copied
        # directly from the public key file.  e.g. pbcopy < ~/.ssh/id_dsa.pub
        # We're going to use the native ssh_authorized_key type to manage these.
        users_hash[title]['sshkeys'].each do |keyline|
          # Split up the raw key file the user provided in the data file.
          (my_type, my_key, my_name)  = keyline.split(' ', 3)
          # Derive the target from the home directory attribute of the account we're managing.
          my_target = File.join(param_hash['home'], '.ssh', 'authorized_keys')
          # Declare the key resource in the catlog
          ssh_authorized_key("#{title}_#{my_type}_#{my_name}",
                             :ensure  => 'present',
                             :user    => title,
                             :name    => my_name,
                             :key     => my_key,
                             :type    => my_type,
                             :target  => my_target,
                             :require => [ "File[#{File.join(param_hash['home'], '.ssh')}]" ])
        end
      else
        file(File.join(param_hash['home'], '.ssh', 'authorized_keys'),
             :ensure  => 'file',
             :owner   => title,
             :group   => title,
             :mode    => '0600')
      end
    end
  end


end
