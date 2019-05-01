# From useradd(8): It is usually recommended to only use usernames that begin
# with a lower case letter or an underscore, followed by lower case letters,
# digits, underscores, or dashes. They can end with a dollar sign.
# Usernames may only be up to 32 characters long.
#
# Some installations also allow periods, for example to separate first and
# last names.

type Accounts::User::Name = Pattern[/\A[a-z_]([a-z.0-9_-]{0,30}[a-z0-9_$-])?\z/]
