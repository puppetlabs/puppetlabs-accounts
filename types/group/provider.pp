# Group provider.
# @summary The specific backend to use for this group resource.
# You will seldom need to specify this -- Puppet will usually discover the
# appropriate provider for your platform.
#
type Accounts::Group::Provider = Enum[
  'aix',
  'directoryservice',
  'groupadd',
  'ldap',
  'pw',
  'windows_adsi'
]
