# Password warning days.
# @summary Number of days before password expiration that a warning is given.
# On most systems, the default value of 7 is common.
#
type Accounts::User::PasswordWarn = Integer[0, 99999]
