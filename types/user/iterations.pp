# Password hash iterations.
# @summary Chained computation iterations for the PBKDF2 password hash.
# This parameter is used in OS X, and is required for managing passwords
# on OS X 10.8 and newer.
#
type Accounts::User::Iterations = Variant[
  Integer[1,],
  Pattern[/\A[1-9]\d*\z/],
]
