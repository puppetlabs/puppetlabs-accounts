# Group attributes hash.
# @summary A hash of group attributes.
# Passed as the third parameter of the ensure_resources function.
#
type Accounts::Group::Resource = Struct[
  { Optional[ensure]          => Enum['absent', 'present'],
    Optional[allowdupe]       => Boolean,
    Optional[auth_membership] => Boolean,
    Optional[forcelocal]      => Boolean,
    Optional[gid]             => Accounts::User::Uid,
    Optional[members]         => Array[Accounts::User::Name],
    Optional[name]            => Accounts::User::Name,
    Optional[provider]        => Accounts::Group::Provider,
    Optional[system]          => Boolean,
  }
]
