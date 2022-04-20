# @summary
#   This class auto-creates user and group resources from hiera data.
#
# @param group_defaults
#   Hash of default attributes for group resources managed by this class.
#
# @param group_list
#   Hash of group resources for this class to manage. The hash is keyed by
#   group name.
#
# @param user_defaults
#   Hash of default attributes for accounts::user resources managed by this
#   class.
#
# @param user_list
#   Hash of accounts::user resources for this class to manage. The hash is
#   keyed by user name.
#
class accounts (
  Accounts::Group::Resource $group_defaults = {},
  Accounts::Group::Hash     $group_list     = {},
  Accounts::User::Resource  $user_defaults  = {},
  Accounts::User::Hash      $user_list      = {},
) {
  ensure_resources('group',          $group_list, $group_defaults)
  ensure_resources('accounts::user', $user_list,  $user_defaults)
}
