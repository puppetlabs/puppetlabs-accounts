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
class accounts::users (
  $users_hash
) {

  validate_hash($users_hash)
  $users_hash_real = $users_hash

  # JJM FIXME This will need to be re-factored
  # When Puppet 2.7 is included in PE since the create_resources
  # function will be part of core.
  create_resources('user', $users_hash_real)

}
