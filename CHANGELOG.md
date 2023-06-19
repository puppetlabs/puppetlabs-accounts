<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v8.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v8.1.0) - 2023-06-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v8.0.0...v8.1.0)

### Added

- CONT-593_adding deferred function [#447](https://github.com/puppetlabs/puppetlabs-accounts/pull/447) ([malikparvez](https://github.com/malikparvez))
- pdksync - (MAINT) - Allow Stdlib 9.x [#446](https://github.com/puppetlabs/puppetlabs-accounts/pull/446) ([LukasAud](https://github.com/LukasAud))

### Fixed

- Remove workaround from user.pp [#439](https://github.com/puppetlabs/puppetlabs-accounts/pull/439) ([CoreyCook8](https://github.com/CoreyCook8))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v8.0.0) - 2023-04-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.3.1...v8.0.0)

### Changed
- (CONT-850) Puppet 8 support / Drop Puppet 6 [#441](https://github.com/puppetlabs/puppetlabs-accounts/pull/441) ([LukasAud](https://github.com/LukasAud))

## [v7.3.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.3.1) - 2023-01-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.3.0...v7.3.1)

### Fixed

- Update bash_profile so that it identifies itself as "Puppet Managed" [#426](https://github.com/puppetlabs/puppetlabs-accounts/pull/426) ([bschonec](https://github.com/bschonec))
- pdksync - (CONT-189) Remove support for RedHat6 / OracleLinux6 / Scientific6 [#424](https://github.com/puppetlabs/puppetlabs-accounts/pull/424) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) Dropping Support for Debian 9 [#421](https://github.com/puppetlabs/puppetlabs-accounts/pull/421) ([jordanbreen28](https://github.com/jordanbreen28))

## [v7.3.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.3.0) - 2022-10-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.2.0...v7.3.0)

### Added

- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#414](https://github.com/puppetlabs/puppetlabs-accounts/pull/414) ([david22swan](https://github.com/david22swan))
- pdksync - (GH-cat-12) Add Support for Redhat 9 [#413](https://github.com/puppetlabs/puppetlabs-accounts/pull/413) ([david22swan](https://github.com/david22swan))

### Fixed

- Fix sshkey_mode bug [#415](https://github.com/puppetlabs/puppetlabs-accounts/pull/415) ([holtwilkins](https://github.com/holtwilkins))

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

## [v7.1.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.1.1) - 2021-08-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.1.0...v7.1.1)

### Fixed

- (IAC-1741) Allow stdlib v8.0.0 [#392](https://github.com/puppetlabs/puppetlabs-accounts/pull/392) ([david22swan](https://github.com/david22swan))

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.1.0) - 2021-08-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.2...v7.1.0)

### Added

- pdksync - (IAC-1709) - Add Support for Debian 11 [#391](https://github.com/puppetlabs/puppetlabs-accounts/pull/391) ([david22swan](https://github.com/david22swan))
- MODULES-11100 - Add sk-ecdsa public key support, and implement tests for sk-ecdsa and ecdsa keys [#388](https://github.com/puppetlabs/puppetlabs-accounts/pull/388) ([vollmerk](https://github.com/vollmerk))

## [v7.0.2](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.2) - 2021-03-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.1...v7.0.2)

### Fixed

- (IAC-1497) - Removal of unsupported `translate` dependency [#373](https://github.com/puppetlabs/puppetlabs-accounts/pull/373) ([david22swan](https://github.com/david22swan))
- (MODULES-10892) Update name.pp [#353](https://github.com/puppetlabs/puppetlabs-accounts/pull/353) ([LooOOooM](https://github.com/LooOOooM))

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.1) - 2021-03-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v7.0.0...v7.0.1)

### Fixed

- (MODULES-10960) Selector needs multiple checks in brackets. [#369](https://github.com/puppetlabs/puppetlabs-accounts/pull/369) ([tuxmea](https://github.com/tuxmea))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v7.0.0) - 2021-03-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.4.0...v7.0.0)

### Changed
- Update metadata.json - remove ubuntu 14.04 [#368](https://github.com/puppetlabs/puppetlabs-accounts/pull/368) ([daianamezdrea](https://github.com/daianamezdrea))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#359](https://github.com/puppetlabs/puppetlabs-accounts/pull/359) ([carabasdaniel](https://github.com/carabasdaniel))

### Fixed

- (MODULES-10867) Ensure ssh key name is unique based on type, content and description [#340](https://github.com/puppetlabs/puppetlabs-accounts/pull/340) ([mdklapwijk](https://github.com/mdklapwijk))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.4.0) - 2020-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.3.0...v6.4.0)

### Added

- pdksync - (maint) - Add support for Puppet 7 [#350](https://github.com/puppetlabs/puppetlabs-accounts/pull/350) ([pmcmaw](https://github.com/pmcmaw))
- MODULES-10862 add support for authorized_keys file mode [#338](https://github.com/puppetlabs/puppetlabs-accounts/pull/338) ([simondeziel](https://github.com/simondeziel))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.3.0) - 2020-09-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.2.0...v6.3.0)

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.2.0) - 2020-09-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.1.1...v6.2.0)

### Added

- Allow for Sensitive type passwords in accounts::user [#333](https://github.com/puppetlabs/puppetlabs-accounts/pull/333) ([jarretlavallee](https://github.com/jarretlavallee))
- pdksync - (IAC-973) - Update travis/appveyor to run on new default branch main [#318](https://github.com/puppetlabs/puppetlabs-accounts/pull/318) ([david22swan](https://github.com/david22swan))
- (IAC-746) - Add ubuntu 20.04 support [#312](https://github.com/puppetlabs/puppetlabs-accounts/pull/312) ([david22swan](https://github.com/david22swan))

### Fixed

- (MODULES-10798) Ensure group is created for user only if undefined [#334](https://github.com/puppetlabs/puppetlabs-accounts/pull/334) ([michaeltlombardi](https://github.com/michaeltlombardi))
- (IAC-975) - Removal of inappropriate terminology in module [#320](https://github.com/puppetlabs/puppetlabs-accounts/pull/320) ([pmcmaw](https://github.com/pmcmaw))

## [v6.1.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.1.1) - 2020-04-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.1.0...v6.1.1)

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.1.0) - 2020-04-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v6.0.0...v6.1.0)

### Added

- Employ more lenient username checks (allow capitals) [#286](https://github.com/puppetlabs/puppetlabs-accounts/pull/286) ([mvandegarde](https://github.com/mvandegarde))
- (MODULES-10242) Re-add Ubuntu 14 to supported OS list [#281](https://github.com/puppetlabs/puppetlabs-accounts/pull/281) ([sheenaajay](https://github.com/sheenaajay))

### Fixed

- MODULES-10550 fix keyspec parsing to allow whitespaces in options and… [#291](https://github.com/puppetlabs/puppetlabs-accounts/pull/291) ([janit42](https://github.com/janit42))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v6.0.0) - 2019-11-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v5.0.0...v6.0.0)

### Added

- (FM-8671) - Support added for CentOS 8 [#278](https://github.com/puppetlabs/puppetlabs-accounts/pull/278) ([david22swan](https://github.com/david22swan))

### Changed
- pdksync - FM-8499 - remove ubuntu14 support [#277](https://github.com/puppetlabs/puppetlabs-accounts/pull/277) ([lionce](https://github.com/lionce))

### Fixed

- fix small typo on the root_home key at Debian.yaml [#260](https://github.com/puppetlabs/puppetlabs-accounts/pull/260) ([wandenberg](https://github.com/wandenberg))
- Use user group instead of user name for sshkey owner group [#258](https://github.com/puppetlabs/puppetlabs-accounts/pull/258) ([florindragos](https://github.com/florindragos))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v5.0.0) - 2019-09-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.2.0...v5.0.0)

### Added

- (FM-8392) Add debian 10 to provision.yaml [#251](https://github.com/puppetlabs/puppetlabs-accounts/pull/251) ([ThoughtCrhyme](https://github.com/ThoughtCrhyme))

### Changed
- (MODULES-9712) Move data into hiera. [#241](https://github.com/puppetlabs/puppetlabs-accounts/pull/241) ([pillarsdotnet](https://github.com/pillarsdotnet))

### Fixed

- (MODULES-9849) wrong order when removing user with custom sshkey file [#250](https://github.com/puppetlabs/puppetlabs-accounts/pull/250) ([tuxmea](https://github.com/tuxmea))
- fix problematic parsing of keyspec [#246](https://github.com/puppetlabs/puppetlabs-accounts/pull/246) ([EECOLOR](https://github.com/EECOLOR))
- (MODULES-9697) fix for correct management of sshkey_custom_path [#242](https://github.com/puppetlabs/puppetlabs-accounts/pull/242) ([tuxmea](https://github.com/tuxmea))

## [v4.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.2.0) - 2019-08-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.1.0...v4.2.0)

### Added

- (FM-8231) Convert testing to litmus [#230](https://github.com/puppetlabs/puppetlabs-accounts/pull/230) ([eimlav](https://github.com/eimlav))

### Fixed

- MODULES-9447 -- Narrow dependency between removed user and group. [#232](https://github.com/puppetlabs/puppetlabs-accounts/pull/232) ([pillarsdotnet](https://github.com/pillarsdotnet))

## [v4.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.1.0) - 2019-05-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/v4.0.0...v4.1.0)

### Added

- (FM-8023) Add RedHat 8 support [#227](https://github.com/puppetlabs/puppetlabs-accounts/pull/227) ([eimlav](https://github.com/eimlav))
- (MODULES-7469) Add password_max_age parameter [#221](https://github.com/puppetlabs/puppetlabs-accounts/pull/221) ([eimlav](https://github.com/eimlav))

### Fixed

- (MODULES-8968) Test account removal. [#226](https://github.com/puppetlabs/puppetlabs-accounts/pull/226) ([pillarsdotnet](https://github.com/pillarsdotnet))

## [v4.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/v4.0.0) - 2019-05-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.2.0...v4.0.0)

### Changed
- pdksync - (MODULES-8444) - Raise lower Puppet bound [#218](https://github.com/puppetlabs/puppetlabs-accounts/pull/218) ([david22swan](https://github.com/david22swan))
- (MODULES-8909) Add type-aliases and auto-loading. [#214](https://github.com/puppetlabs/puppetlabs-accounts/pull/214) ([pillarsdotnet](https://github.com/pillarsdotnet))

### Fixed

- (MODULES-8909) Allow periods in usernames. [#220](https://github.com/puppetlabs/puppetlabs-accounts/pull/220) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Remove user when custom sshkey file is set [#213](https://github.com/puppetlabs/puppetlabs-accounts/pull/213) ([tuxmea](https://github.com/tuxmea))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.2.0) - 2019-01-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.1.0...3.2.0)

### Added

- (MODULES-8302) - Add allowdupe parameter [#199](https://github.com/puppetlabs/puppetlabs-accounts/pull/199) ([eimlav](https://github.com/eimlav))
- (MODULES-8149) - Addition of support for SLES 15 [#197](https://github.com/puppetlabs/puppetlabs-accounts/pull/197) ([david22swan](https://github.com/david22swan))

### Fixed

- (MODULES-8216) - Fix fail when custom_sshkey_path and managehome=false [#194](https://github.com/puppetlabs/puppetlabs-accounts/pull/194) ([eimlav](https://github.com/eimlav))
- Fixing the limitations section of the README [#191](https://github.com/puppetlabs/puppetlabs-accounts/pull/191) ([HelenCampbell](https://github.com/HelenCampbell))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.1.0) - 2018-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/3.0.0...3.1.0)

### Added

- pdksync - (FM-7392) puppet 6 testing changes [#187](https://github.com/puppetlabs/puppetlabs-accounts/pull/187) ([tphoney](https://github.com/tphoney))
- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#185](https://github.com/puppetlabs/puppetlabs-accounts/pull/185) ([tphoney](https://github.com/tphoney))
- (LOC-173) Delivering translation for readmes/README_ja_JP.markdown [#177](https://github.com/puppetlabs/puppetlabs-accounts/pull/177) ([ehom](https://github.com/ehom))

### Fixed

- (maint) corrected filename extension for both en and ja [#182](https://github.com/puppetlabs/puppetlabs-accounts/pull/182) ([ehom](https://github.com/ehom))
- Only take care of ssh-keys if ensure is set to 'present' [#174](https://github.com/puppetlabs/puppetlabs-accounts/pull/174) ([opteamax](https://github.com/opteamax))
- Rename README.markdown to README.MD [#173](https://github.com/puppetlabs/puppetlabs-accounts/pull/173) ([clairecadman](https://github.com/clairecadman))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/3.0.0) - 2018-09-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/2.0.0...3.0.0)

### Added

- (MODULES-7687) - Added Darwin compatibility [#167](https://github.com/puppetlabs/puppetlabs-accounts/pull/167) ([eimlav](https://github.com/eimlav))
- (FM-7287) - i18n Process Implemented. [#159](https://github.com/puppetlabs/puppetlabs-accounts/pull/159) ([david22swan](https://github.com/david22swan))
- (MODULES-5222) - managevim option added to manifests.  [#156](https://github.com/puppetlabs/puppetlabs-accounts/pull/156) ([david22swan](https://github.com/david22swan))
- (FM-7289) - Added Puppet 4 data types to parameters [#155](https://github.com/puppetlabs/puppetlabs-accounts/pull/155) ([eimlav](https://github.com/eimlav))
- (MODULES-7671) - Support spaces in ssh key options [#153](https://github.com/puppetlabs/puppetlabs-accounts/pull/153) ([dleske](https://github.com/dleske))
- (FM-7254) - Addition of support for Ubuntu 18.04 [#150](https://github.com/puppetlabs/puppetlabs-accounts/pull/150) ([david22swan](https://github.com/david22swan))

### Changed
- Adding ability to specify custom ssh_key location [#149](https://github.com/puppetlabs/puppetlabs-accounts/pull/149) ([ggeldenhuis](https://github.com/ggeldenhuis))

### Fixed

- pdksync - (MODULES-7658) use beaker4 in puppet-module-gems [#170](https://github.com/puppetlabs/puppetlabs-accounts/pull/170) ([tphoney](https://github.com/tphoney))
- Fix error when deploying key into directory not owned by user [#152](https://github.com/puppetlabs/puppetlabs-accounts/pull/152) ([tuxmea](https://github.com/tuxmea))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/2.0.0) - 2018-06-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/1.3.0...2.0.0)

### Added

- Add expiry property to user resource. [#145](https://github.com/puppetlabs/puppetlabs-accounts/pull/145) ([jonnytdevops](https://github.com/jonnytdevops))
- (FM-7052) - Addition of Debian 9 support to accounts [#144](https://github.com/puppetlabs/puppetlabs-accounts/pull/144) ([david22swan](https://github.com/david22swan))

### Changed
- [FM-6969] Removal of unsupported OS from accounts [#143](https://github.com/puppetlabs/puppetlabs-accounts/pull/143) ([david22swan](https://github.com/david22swan))

### Other

- pdksync - Update using 1.5.0 [#142](https://github.com/puppetlabs/puppetlabs-accounts/pull/142) ([HelenCampbell](https://github.com/HelenCampbell))
- pdksync - Update using 1.5.0 [#136](https://github.com/puppetlabs/puppetlabs-accounts/pull/136) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-7153) - Unmanage gitlab-ci.yml [#135](https://github.com/puppetlabs/puppetlabs-accounts/pull/135) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-7023) - Removing duplication in .sync.yml [#134](https://github.com/puppetlabs/puppetlabs-accounts/pull/134) ([pmcmaw](https://github.com/pmcmaw))
- (maint) - PDK Update Accounts [#131](https://github.com/puppetlabs/puppetlabs-accounts/pull/131) ([pmcmaw](https://github.com/pmcmaw))
- Allow sshkeys to be reused for multiple accounts [#130](https://github.com/puppetlabs/puppetlabs-accounts/pull/130) ([jcharaoui](https://github.com/jcharaoui))
- (MODULES-6607) - Update docs to reflect correct default value for ignore_password_if_empty. [#129](https://github.com/puppetlabs/puppetlabs-accounts/pull/129) ([pmcmaw](https://github.com/pmcmaw))
- Release merge back 1.3.0  [#127](https://github.com/puppetlabs/puppetlabs-accounts/pull/127) ([pmcmaw](https://github.com/pmcmaw))
- Allow mode for homedir to be undef [#126](https://github.com/puppetlabs/puppetlabs-accounts/pull/126) ([arjenz](https://github.com/arjenz))

## [1.3.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/1.3.0) - 2018-01-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/1.2.1...1.3.0)

### Other

- Release Prep 1.3.0 [#125](https://github.com/puppetlabs/puppetlabs-accounts/pull/125) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-6328) - PDK Convert accounts [#124](https://github.com/puppetlabs/puppetlabs-accounts/pull/124) ([pmcmaw](https://github.com/pmcmaw))
- Don't create accounts::home_dir resources [#123](https://github.com/puppetlabs/puppetlabs-accounts/pull/123) ([arjenz](https://github.com/arjenz))
- (maint) modulesync 65530a4 Update Travis [#122](https://github.com/puppetlabs/puppetlabs-accounts/pull/122) ([michaeltlombardi](https://github.com/michaeltlombardi))
- (maint) - modulesync 384f4c1 [#121](https://github.com/puppetlabs/puppetlabs-accounts/pull/121) ([tphoney](https://github.com/tphoney))
- (FM-6634) - Addressing Rubocop errors [#120](https://github.com/puppetlabs/puppetlabs-accounts/pull/120) ([pmcmaw](https://github.com/pmcmaw))
- Release merge back 1.2.1 [#118](https://github.com/puppetlabs/puppetlabs-accounts/pull/118) ([pmcmaw](https://github.com/pmcmaw))

## [1.2.1](https://github.com/puppetlabs/puppetlabs-accounts/tree/1.2.1) - 2017-11-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/1.2.0...1.2.1)

### Other

- (maint) - modulesync 1d81b6a [#117](https://github.com/puppetlabs/puppetlabs-accounts/pull/117) ([pmcmaw](https://github.com/pmcmaw))
- (maint) fix up the .sync.yml [#116](https://github.com/puppetlabs/puppetlabs-accounts/pull/116) ([tphoney](https://github.com/tphoney))
- Release prep for 1.2.1 [#115](https://github.com/puppetlabs/puppetlabs-accounts/pull/115) ([willmeek](https://github.com/willmeek))
- Cleanup ruby code via rubocop [#114](https://github.com/puppetlabs/puppetlabs-accounts/pull/114) ([willmeek](https://github.com/willmeek))
- Release mergeback 1.2.0 [#113](https://github.com/puppetlabs/puppetlabs-accounts/pull/113) ([pmcmaw](https://github.com/pmcmaw))

## [1.2.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/1.2.0) - 2017-11-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/1.1.0...1.2.0)

### Added

- Support ssh authorized key options [#110](https://github.com/puppetlabs/puppetlabs-accounts/pull/110) ([rgevaert](https://github.com/rgevaert))

### Other

- minor fixups in README [#112](https://github.com/puppetlabs/puppetlabs-accounts/pull/112) ([jbondpdx](https://github.com/jbondpdx))
- Further 1.2.0 Release Prep [#111](https://github.com/puppetlabs/puppetlabs-accounts/pull/111) ([willmeek](https://github.com/willmeek))
- MODULES-5600 Add support for .forward [#109](https://github.com/puppetlabs/puppetlabs-accounts/pull/109) ([rgevaert](https://github.com/rgevaert))
- 1.2.0 Release Prep [#108](https://github.com/puppetlabs/puppetlabs-accounts/pull/108) ([willmeek](https://github.com/willmeek))
- Update group acceptance tests for SLES and Solaris [#106](https://github.com/puppetlabs/puppetlabs-accounts/pull/106) ([willmeek](https://github.com/willmeek))
- Skips password check test on Solaris [#105](https://github.com/puppetlabs/puppetlabs-accounts/pull/105) ([willmeek](https://github.com/willmeek))
- (MODULES-5778) Set operatingsystem fact in specs [#104](https://github.com/puppetlabs/puppetlabs-accounts/pull/104) ([rodjek](https://github.com/rodjek))
- Group dependency tests [#103](https://github.com/puppetlabs/puppetlabs-accounts/pull/103) ([willmeek](https://github.com/willmeek))
- Empty password test [#102](https://github.com/puppetlabs/puppetlabs-accounts/pull/102) ([willmeek](https://github.com/willmeek))
- remove whitespace from EOL [#100](https://github.com/puppetlabs/puppetlabs-accounts/pull/100) ([tphoney](https://github.com/tphoney))
- (maint) modulesync 892c4cf [#98](https://github.com/puppetlabs/puppetlabs-accounts/pull/98) ([HAIL9000](https://github.com/HAIL9000))
- (maint) - Removing Ubuntu 12.04 [#96](https://github.com/puppetlabs/puppetlabs-accounts/pull/96) ([pmcmaw](https://github.com/pmcmaw))
- (maint) modulesync 915cde70e20 [#94](https://github.com/puppetlabs/puppetlabs-accounts/pull/94) ([glennsarti](https://github.com/glennsarti))
- (MODULES-5187) mysnc puppet 5 and ruby 2.4 [#92](https://github.com/puppetlabs/puppetlabs-accounts/pull/92) ([eputnam](https://github.com/eputnam))
- (MODULES-5199) Prep for puppet 5 [#90](https://github.com/puppetlabs/puppetlabs-accounts/pull/90) ([hunner](https://github.com/hunner))
- Update Puppet version compatibility [#87](https://github.com/puppetlabs/puppetlabs-accounts/pull/87) ([HelenCampbell](https://github.com/HelenCampbell))
- Group name [#85](https://github.com/puppetlabs/puppetlabs-accounts/pull/85) ([wpowell-ossg](https://github.com/wpowell-ossg))
- [msync] 786266 Implement puppet-module-gems, a45803 Remove metadata.json from locales config [#84](https://github.com/puppetlabs/puppetlabs-accounts/pull/84) ([wilson208](https://github.com/wilson208))
- [MODULES-4528] Replace Puppet.version.to_f version comparison from spec_helper.rb [#83](https://github.com/puppetlabs/puppetlabs-accounts/pull/83) ([wilson208](https://github.com/wilson208))
- added option to set system user or group [#82](https://github.com/puppetlabs/puppetlabs-accounts/pull/82) ([netman2k](https://github.com/netman2k))
- Added the option to create or not a group with the user name [#81](https://github.com/puppetlabs/puppetlabs-accounts/pull/81) ([jsanvall](https://github.com/jsanvall))
- [MODULES-4224] Implement beaker-module_install_helper [#79](https://github.com/puppetlabs/puppetlabs-accounts/pull/79) ([wilson208](https://github.com/wilson208))
- (MODULES-4098) Sync the rest of the files [#78](https://github.com/puppetlabs/puppetlabs-accounts/pull/78) ([hunner](https://github.com/hunner))
- (FM-5972) gettext and spec.opts [#77](https://github.com/puppetlabs/puppetlabs-accounts/pull/77) ([eputnam](https://github.com/eputnam))
- (MODULES-3631) msync Gemfile for 1.9 frozen strings [#76](https://github.com/puppetlabs/puppetlabs-accounts/pull/76) ([hunner](https://github.com/hunner))
- Revert "Allow duplicate keys to be associated with multiple accounts." [#75](https://github.com/puppetlabs/puppetlabs-accounts/pull/75) ([eputnam](https://github.com/eputnam))
- Allow the use of the `source` param for bash files. [#74](https://github.com/puppetlabs/puppetlabs-accounts/pull/74) ([MG2R](https://github.com/MG2R))
- (MODULES-3983) Update parallel_tests for ruby 2.0.0 [#72](https://github.com/puppetlabs/puppetlabs-accounts/pull/72) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-3704) Update gemfile template like windows [#71](https://github.com/puppetlabs/puppetlabs-accounts/pull/71) ([hunner](https://github.com/hunner))
- Update modulesync_config [51f469d] [#70](https://github.com/puppetlabs/puppetlabs-accounts/pull/70) ([DavidS](https://github.com/DavidS))
- Release mergeback [#69](https://github.com/puppetlabs/puppetlabs-accounts/pull/69) ([HelenCampbell](https://github.com/HelenCampbell))
- the simple usage example has some erros [#63](https://github.com/puppetlabs/puppetlabs-accounts/pull/63) ([roock](https://github.com/roock))
- Allow duplicate keys to be associated with multiple accounts. [#54](https://github.com/puppetlabs/puppetlabs-accounts/pull/54) ([ian-d](https://github.com/ian-d))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/1.1.0) - 2016-09-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/1.0.0...1.1.0)

### Other

- 1.1.0 Release Prep [#68](https://github.com/puppetlabs/puppetlabs-accounts/pull/68) ([HelenCampbell](https://github.com/HelenCampbell))
- Update modulesync_config [a3fe424] [#65](https://github.com/puppetlabs/puppetlabs-accounts/pull/65) ([DavidS](https://github.com/DavidS))
- Update modulesync_config [0d59329] [#64](https://github.com/puppetlabs/puppetlabs-accounts/pull/64) ([DavidS](https://github.com/DavidS))
- (MAINT) Update for modulesync_config 72d19f184 [#62](https://github.com/puppetlabs/puppetlabs-accounts/pull/62) ([DavidS](https://github.com/DavidS))
- (maint) modulesync f6e2070 [#60](https://github.com/puppetlabs/puppetlabs-accounts/pull/60) ([tphoney](https://github.com/tphoney))
- (MODULES-3560) fixing tests [#59](https://github.com/puppetlabs/puppetlabs-accounts/pull/59) ([tphoney](https://github.com/tphoney))
- Adding osfamily fact to tests. [#55](https://github.com/puppetlabs/puppetlabs-accounts/pull/55) ([ian-d](https://github.com/ian-d))
- Addition of Debian 8 compatibility in metadata [#49](https://github.com/puppetlabs/puppetlabs-accounts/pull/49) ([HelenCampbell](https://github.com/HelenCampbell))
- This isn't needed with BPIH 0.4.2 [#48](https://github.com/puppetlabs/puppetlabs-accounts/pull/48) ([hunner](https://github.com/hunner))
- Unpin rspec-puppet [#47](https://github.com/puppetlabs/puppetlabs-accounts/pull/47) ([hunner](https://github.com/hunner))
- 1.0.x [#45](https://github.com/puppetlabs/puppetlabs-accounts/pull/45) ([hunner](https://github.com/hunner))
- Edited readme file. [#44](https://github.com/puppetlabs/puppetlabs-accounts/pull/44) ([mindymo](https://github.com/mindymo))
- Allow non-managed SSH keys to be purged from user. [#42](https://github.com/puppetlabs/puppetlabs-accounts/pull/42) ([ian-d](https://github.com/ian-d))
- 1.0.x mergeback [#40](https://github.com/puppetlabs/puppetlabs-accounts/pull/40) ([bmjen](https://github.com/bmjen))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-accounts/tree/1.0.0) - 2015-12-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-accounts/compare/0bc97479b2c35d02d4cb475ae7cd42972a6f9c92...1.0.0)
