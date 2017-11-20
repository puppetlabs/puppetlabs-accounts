# Change log
All notable changes to this project will be documented in this file.

## Supported Release [1.2.1]
### Summary
This release is to update the formatting of the module, Rubocop having been run for all ruby files and been set to run automatically on all future commits.

### Changed
- Rubocop has been implemented.

## Supported Release 1.2.0
### Summary
This release is a rollup of changes. Several attributes have been added as requested and submitted from our community.

#### Added
- Attribute ignore_password\_if\_empty is added which, if set to true, shall ignore password changes if the password is empty.
- Removal of dependency on group resource if create\_group is set to false.
- Add attribute to allow custom group names.
- Add attribute to set system user or group.
- Add attribute to set the user or group to be the system account.
- Add attribute to create a group (or not) with the username.
- Add support for .forward.
- Add support for ssh options in authorization_keys.
- Add ECDSA support.
- Add support for ssh authorized key options.
- Allow the use of the \`source\` param for bash files
- Removal of end-of-life Ubuntu 12.04 support from metadata.
- Update Puppet version compatibility.
- Modulesync and Gemfile updates.

#### Fixed
- Multiple fixes to tests.

## Supported Release 1.1.0
### Summary
A feature rich release, with the addition of Debian 8 support. Also several generic fixes to tests.

#### Features
- Now allows SSH keys to be purged from user.
- Multiple updates and fixes to the README.
- RSpec-puppet has now been unpinned.
- Addition of Debian 8 compatibility to metadata.
- Addition of OSfamily fact to tests.
- Several modulesync updates.

#### Bugfixes
- Multiple fixes to tests.

## Supported Release 1.0.0 
### Summary:
This is the initial release of the rewrite of puppetlabs-pe\_accounts for a more general usage.

Differences from the pe\_accounts module is that the data model is gone, and thus the base class that accepts hashes (ie, from hiera). Instead, the module is designed around the use of the `accounts::user` defined resource.

To regain the old hiera behavior, use the `create_resources()` function in combination with `accounts::user`; eg: `create_resources('accounts::user', hiera_hash('accounts::users'))`

[1.2.1]:https://github.com/puppetlabs/puppetlabs-accounts/compare/1.2.0...1.2.1