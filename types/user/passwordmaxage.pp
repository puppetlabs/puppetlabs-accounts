# Typically a value of 99999 is used to disable password aging as this is about 274 years.
# This is usually the default value on most systems.

type Accounts::User::PasswordMaxAge = Integer[1, 99999]
