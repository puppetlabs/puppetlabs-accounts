# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [3.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.2.0) (2019-01-18)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.1.0...3.2.0)

### Added

- \(MODULES-8302\) - Add allowdupe parameter [\#199](https://github.com/puppetlabs/puppetlabs-accounts/pull/199) ([eimlav](https://github.com/eimlav))
- \(MODULES-8149\) - Addition of support for SLES 15 [\#197](https://github.com/puppetlabs/puppetlabs-accounts/pull/197) ([david22swan](https://github.com/david22swan))

### Fixed

- \(MODULES-8216\) - Fix fail when custom\_sshkey\_path and managehome=false [\#194](https://github.com/puppetlabs/puppetlabs-accounts/pull/194) ([eimlav](https://github.com/eimlav))
- Fixing the limitations section of the README [\#191](https://github.com/puppetlabs/puppetlabs-accounts/pull/191) ([HelenCampbell](https://github.com/HelenCampbell))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.1.0) (2018-09-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.0.0...3.1.0)

### Added

- pdksync - \(FM-7392\) puppet 6 testing changes [\#187](https://github.com/puppetlabs/puppetlabs-accounts/pull/187) ([tphoney](https://github.com/tphoney))
- pdksync - \(MODULES-6805\) metadata.json shows support for puppet 6 [\#185](https://github.com/puppetlabs/puppetlabs-accounts/pull/185) ([tphoney](https://github.com/tphoney))
- \(LOC-173\) Delivering translation for readmes/README\_ja\_JP.markdown [\#177](https://github.com/puppetlabs/puppetlabs-accounts/pull/177) ([ehom](https://github.com/ehom))

### Fixed

- \(maint\) corrected filename extension for both en and ja [\#182](https://github.com/puppetlabs/puppetlabs-accounts/pull/182) ([ehom](https://github.com/ehom))
- Only take care of ssh-keys if ensure is set to 'present' [\#174](https://github.com/puppetlabs/puppetlabs-accounts/pull/174) ([opteamax](https://github.com/opteamax))
- Rename README.markdown to README.MD [\#173](https://github.com/puppetlabs/puppetlabs-accounts/pull/173) ([clairecadman](https://github.com/clairecadman))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.0.0) (2018-09-07)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/2.0.0...3.0.0)

### Changed

- Adding ability to specify custom ssh\_key location [\#149](https://github.com/puppetlabs/puppetlabs-accounts/pull/149) ([ggeldenhuis](https://github.com/ggeldenhuis))

### Added

- \(MODULES-7687\) - Added Darwin compatibility [\#167](https://github.com/puppetlabs/puppetlabs-accounts/pull/167) ([eimlav](https://github.com/eimlav))
- \(FM-7287\) - i18n Process Implemented. [\#159](https://github.com/puppetlabs/puppetlabs-accounts/pull/159) ([david22swan](https://github.com/david22swan))
- \(MODULES-5222\) - managevim option added to manifests.  [\#156](https://github.com/puppetlabs/puppetlabs-accounts/pull/156) ([david22swan](https://github.com/david22swan))
- \(FM-7289\) - Added Puppet 4 data types to parameters [\#155](https://github.com/puppetlabs/puppetlabs-accounts/pull/155) ([eimlav](https://github.com/eimlav))
- \(MODULES-7671\) - Support spaces in ssh key options [\#153](https://github.com/puppetlabs/puppetlabs-accounts/pull/153) ([dleske](https://github.com/dleske))
- \(FM-7254\) - Addition of support for Ubuntu 18.04 [\#150](https://github.com/puppetlabs/puppetlabs-accounts/pull/150) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - \(MODULES-7658\) use beaker4 in puppet-module-gems [\#170](https://github.com/puppetlabs/puppetlabs-accounts/pull/170) ([tphoney](https://github.com/tphoney))
- Fix error when deploying key into directory not owned by user [\#152](https://github.com/puppetlabs/puppetlabs-accounts/pull/152) ([tuxmea](https://github.com/tuxmea))

## 2.0.0
### Summary
This release drops support for Debian 7, adds support for Debian 9 and includes several small features and bug fixes.

#### Added
- [FM-7052] Addition of Debian 9 support to accounts
- (MODULES-3989) Allow management of local accounts despite an NSS
- Allow mode for homedir to be undef
- Add expiry property to user resource.

#### Fixed
- (MODULES-6607) - Update docs to reflect correct default value for ignore_password_if_empty.
- Update tests and README
- Removed Debian 7 support

#### Bugfixes
- Allow sshkeys to be reused for multiple accounts
- Set `home_mode` explicitly in tests
- Fix test for ssh key to allow new comment format


## Supported Release [1.3.0]
### Summary
This release uses the PDK convert functionality which in return makes the module PDK compliant. It also includes a roll up of maintenance changes.

#### Added
- PDK Convert accounts ([MODULES-6328](https://tickets.puppet.com/browse/MODULES-6328)).

#### Fixed
- Don't create accounts::home_dir resources.
- Multiple maintenance changes.

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

[1.3.0]:https://github.com/puppetlabs/puppetlabs-accounts/compare/1.2.1...1.3.0
[1.2.1]:https://github.com/puppetlabs/puppetlabs-accounts/compare/1.2.0...1.2.1


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
