# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v7.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.2.0) - 2022-05-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.1.1...v7.2.0)

### Added

- Added new SSH key type. [#410](https://github.com/puppetlabs/puppetlabs-accounts/pull/410) ([PorkCharsui79](https://github.com/PorkCharsui79))

- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#397](https://github.com/puppetlabs/puppetlabs-accounts/pull/397) ([david22swan](https://github.com/david22swan))

- pdksync - (IAC-1751) - Add Support for Rocky 8 [#395](https://github.com/puppetlabs/puppetlabs-accounts/pull/395) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - (GH-iac-334) Remove Support for Ubuntu 16.04 [#401](https://github.com/puppetlabs/puppetlabs-accounts/pull/401) ([david22swan](https://github.com/david22swan))

- pdksync - (IAC-1787) Remove Support for CentOS 6 [#398](https://github.com/puppetlabs/puppetlabs-accounts/pull/398) ([david22swan](https://github.com/david22swan))

- pdksync - (IAC-1598) - Remove Support for Debian 8 [#394](https://github.com/puppetlabs/puppetlabs-accounts/pull/394) ([david22swan](https://github.com/david22swan))


## [v7.1.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.1.1) (2021-08-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.1.0...v7.1.1)

### Fixed

- \(IAC-1741\) Allow stdlib v8.0.0 [\#392](https://github.com/puppetlabs/puppetlabs-accounts/pull/392) ([david22swan](https://github.com/david22swan))

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.1.0) (2021-08-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.2...v7.1.0)

### Added

- pdksync - \(IAC-1709\) - Add Support for Debian 11 [\#391](https://github.com/puppetlabs/puppetlabs-accounts/pull/391) ([david22swan](https://github.com/david22swan))
- MODULES-11100 - Add sk-ecdsa public key support, and implement tests for sk-ecdsa and ecdsa keys [\#388](https://github.com/puppetlabs/puppetlabs-accounts/pull/388) ([vollmerk](https://github.com/vollmerk))

## [v7.0.2](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.2) (2021-03-29)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.1...v7.0.2)

### Fixed

- \(IAC-1497\) - Removal of unsupported `translate` dependency [\#373](https://github.com/puppetlabs/puppetlabs-accounts/pull/373) ([david22swan](https://github.com/david22swan))
- \(MODULES-10892\) Update name.pp [\#353](https://github.com/puppetlabs/puppetlabs-accounts/pull/353) ([LooOOooM](https://github.com/LooOOooM))

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.1) (2021-03-15)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.0...v7.0.1)

### Fixed

- \(MODULES-10960\) Selector needs multiple checks in brackets. [\#369](https://github.com/puppetlabs/puppetlabs-accounts/pull/369) ([tuxmea](https://github.com/tuxmea))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.0) (2021-03-01)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.4.0...v7.0.0)

### Changed

- Update metadata.json - remove ubuntu 14.04 [\#368](https://github.com/puppetlabs/puppetlabs-accounts/pull/368) ([daianamezdrea](https://github.com/daianamezdrea))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [\#359](https://github.com/puppetlabs/puppetlabs-accounts/pull/359) ([carabasdaniel](https://github.com/carabasdaniel))

### Fixed

- \(MODULES-10867\) Ensure ssh key name is unique based on type, content and description [\#340](https://github.com/puppetlabs/puppetlabs-accounts/pull/340) ([mdklapwijk](https://github.com/mdklapwijk))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.4.0) (2020-12-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.3.0...v6.4.0)

### Added

- pdksync - \(maint\) - Add support for Puppet 7 [\#350](https://github.com/puppetlabs/puppetlabs-accounts/pull/350) ([pmcmaw](https://github.com/pmcmaw))
- MODULES-10862 add support for authorized\_keys file mode [\#338](https://github.com/puppetlabs/puppetlabs-accounts/pull/338) ([simondeziel](https://github.com/simondeziel))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.3.0) (2020-09-22)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.2.0...v6.3.0)

### Added

- Allow for Sensitive type passwords in accounts::user [\#333](https://github.com/puppetlabs/puppetlabs-accounts/pull/333) ([jarretlavallee](https://github.com/jarretlavallee))

### Fixed

- \(MODULES-10798\) Ensure group is created for user only if undefined [\#334](https://github.com/puppetlabs/puppetlabs-accounts/pull/334) ([michaeltlombardi](https://github.com/michaeltlombardi))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.2.0) (2020-08-20)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.1.1...v6.2.0)

### Added

- pdksync - \(IAC-973\) - Update travis/appveyor to run on new default branch main [\#318](https://github.com/puppetlabs/puppetlabs-accounts/pull/318) ([david22swan](https://github.com/david22swan))
- \(IAC-746\) - Add ubuntu 20.04 support [\#312](https://github.com/puppetlabs/puppetlabs-accounts/pull/312) ([david22swan](https://github.com/david22swan))

### Fixed

- \(IAC-975\) - Removal of inappropriate terminology in module [\#320](https://github.com/puppetlabs/puppetlabs-accounts/pull/320) ([pmcmaw](https://github.com/pmcmaw))

## [v6.1.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.1.1) (2020-04-30)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.1.0...v6.1.1)

### Fixed

- MODULES-10550 fix keyspec parsing to allow whitespaces in options and… [\#291](https://github.com/puppetlabs/puppetlabs-accounts/pull/291) ([janit42](https://github.com/janit42))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.1.0) (2020-02-03)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.0.0...v6.1.0)

### Added

- Employ more lenient username checks \(allow capitals\) [\#286](https://github.com/puppetlabs/puppetlabs-accounts/pull/286) ([mvandegarde](https://github.com/mvandegarde))
- \(MODULES-10242\) Re-add Ubuntu 14 to supported OS list [\#281](https://github.com/puppetlabs/puppetlabs-accounts/pull/281) ([sheenaajay](https://github.com/sheenaajay))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.0.0) (2019-11-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v5.0.0...v6.0.0)

### Changed

- pdksync - FM-8499 - remove ubuntu14 support [\#277](https://github.com/puppetlabs/puppetlabs-accounts/pull/277) ([lionce](https://github.com/lionce))

### Added

- \(FM-8671\) - Support added for CentOS 8 [\#278](https://github.com/puppetlabs/puppetlabs-accounts/pull/278) ([david22swan](https://github.com/david22swan))

### Fixed

- fix small typo on the root\_home key at Debian.yaml [\#260](https://github.com/puppetlabs/puppetlabs-accounts/pull/260) ([wandenberg](https://github.com/wandenberg))
- Use user group instead of user name for sshkey owner group [\#258](https://github.com/puppetlabs/puppetlabs-accounts/pull/258) ([florindragos](https://github.com/florindragos))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v5.0.0) (2019-09-10)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.2.0...v5.0.0)

### Changed

- \(MODULES-9712\) Move data into hiera. [\#241](https://github.com/puppetlabs/puppetlabs-accounts/pull/241) ([pillarsdotnet](https://github.com/pillarsdotnet))

### Added

- \(FM-8392\) Add debian 10 to provision.yaml [\#251](https://github.com/puppetlabs/puppetlabs-accounts/pull/251) ([ThoughtCrhyme](https://github.com/ThoughtCrhyme))

### Fixed

- \(MODULES-9849\) wrong order when removing user with custom sshkey file [\#250](https://github.com/puppetlabs/puppetlabs-accounts/pull/250) ([tuxmea](https://github.com/tuxmea))
- fix problematic parsing of keyspec [\#246](https://github.com/puppetlabs/puppetlabs-accounts/pull/246) ([EECOLOR](https://github.com/EECOLOR))
- \(MODULES-9697\) fix for correct management of sshkey\_custom\_path [\#242](https://github.com/puppetlabs/puppetlabs-accounts/pull/242) ([tuxmea](https://github.com/tuxmea))

## [v4.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.2.0) (2019-08-02)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.1.0...v4.2.0)

### Added

- \(FM-8231\) Convert testing to litmus [\#230](https://github.com/puppetlabs/puppetlabs-accounts/pull/230) ([eimlav](https://github.com/eimlav))

### Fixed

- MODULES-9447 -- Narrow dependency between removed user and group. [\#232](https://github.com/puppetlabs/puppetlabs-accounts/pull/232) ([pillarsdotnet](https://github.com/pillarsdotnet))

## [v4.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.1.0) (2019-05-29)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.0.0...v4.1.0)

### Added

- \(FM-8023\) Add RedHat 8 support [\#227](https://github.com/puppetlabs/puppetlabs-accounts/pull/227) ([eimlav](https://github.com/eimlav))
- \(MODULES-7469\) Add password\_max\_age parameter [\#221](https://github.com/puppetlabs/puppetlabs-accounts/pull/221) ([eimlav](https://github.com/eimlav))

### Fixed

- \(MODULES-8968\) Test account removal. [\#226](https://github.com/puppetlabs/puppetlabs-accounts/pull/226) ([pillarsdotnet](https://github.com/pillarsdotnet))

## [v4.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.0.0) (2019-05-10)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.2.0...v4.0.0)

### Changed

- pdksync - \(MODULES-8444\) - Raise lower Puppet bound [\#218](https://github.com/puppetlabs/puppetlabs-accounts/pull/218) ([david22swan](https://github.com/david22swan))
- \(MODULES-8909\) Add type-aliases and auto-loading. [\#214](https://github.com/puppetlabs/puppetlabs-accounts/pull/214) ([pillarsdotnet](https://github.com/pillarsdotnet))

### Fixed

- \(MODULES-8909\) Allow periods in usernames. [\#220](https://github.com/puppetlabs/puppetlabs-accounts/pull/220) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Remove user when custom sshkey file is set [\#213](https://github.com/puppetlabs/puppetlabs-accounts/pull/213) ([tuxmea](https://github.com/tuxmea))

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
