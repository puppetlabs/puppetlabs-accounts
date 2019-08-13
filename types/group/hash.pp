# Group resoureces hash.
# @summary A hash of group resources, keyed by group name.
# Passed as the second parameter of the ensure_resources function.
#
type Accounts::Group::Hash = Hash[
  Accounts::User::Name, Accounts::Group::Resource
]
