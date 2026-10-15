# Password age.
# @summary Maximum days between password changes/password expiration and warning.
# On most systems, the default value of 99999 is about 274 years, which
# effectively disables password aging.
#
type Accounts::User::PasswordAge = Integer[-1, 99999]
