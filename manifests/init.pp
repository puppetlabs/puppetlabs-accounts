# @summary This class auto-creates user and group resources from hiera data.

class accounts (
  Accounts::Group::Resource $group_defaults = {},
  Accounts::Group::Hash     $group_list     = {},
  Accounts::User::Resource  $user_defaults  = {},
  Accounts::User::Hash      $user_list      = {},
)
{
  ensure_resources('group',          $group_list, $group_defaults)
  ensure_resources('accounts::user', $user_list,  $user_defaults)
}
