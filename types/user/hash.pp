# User resources hash.
# @summary A hash of user resources, keyed by user name.
# Passed as the second parameter of the ensure_resources function.
#
type Accounts::User::Hash = Hash[
  Accounts::User::Name, Accounts::User::Resource
]
