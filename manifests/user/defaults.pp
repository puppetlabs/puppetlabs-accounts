# @summary
#   Load some user defaults from hiera data.
#
# @param home_template
#   The sprintf template used to determine a user's home directory.
#
# @param locked_shell
#   The shell assigned to locked user accounts.
#
# @param root_home
#   The home directory of the root user.
#
class accounts::user::defaults (
  Stdlib::AbsolutePath      $home_template = '/home/%s',
  Stdlib::AbsolutePath      $locked_shell = '/sbin/nologin',
  Stdlib::AbsolutePath      $root_home = '/root',
) {
  # Nothing to see here; move along.
}
