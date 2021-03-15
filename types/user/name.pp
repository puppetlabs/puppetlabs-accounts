# Account (user or group) name.
# @summary Each user or group should have a unique alphanumeric name.
# From useradd(8): It is usually recommended to only use usernames
# that begin with a lower case letter or an underscore, followed by lower case 
# letters, digits, underscores, or dashes. They can end with a dollar sign.
# Usernames may only be up to 32 characters long.
#
# Many installations also allow capitals or periods, for example to separate first and
# last names. 
#
type Accounts::User::Name = Pattern[/\A[a-zA-Z0-9_]([a-zA-Z.0-9_-]{0,30}[a-zA-Z0-9_$-])?\z/]
