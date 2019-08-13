# Numeric user ID.
# @summary Each user on a system should have a unique numeric uid.
# On most Unix systems, the highest uid is 2^32 - 1, or 4294967295.
#
type Accounts::User::Uid = Variant[
  Integer[0,4294967295],
  Pattern[/\A0\z/,
          /\A[1-3]\d{0,9}\z/,
          /\A[4-9]\d{0,8}\z/,
          /\A4[0-1]\d{8}\z/,
          /\A42[0-8]\d{7}\z/,
          /\A429[0-3]\d{6}\z/,
          /\A4294[0-8]\d{5}\z/,
          /\A42949[0-5]\d{4}\z/,
          /\A429496[0-6]\d{3}\z/,
          /\A4294967[0-1]\d{2}\z/,
          /\A42949672[0-8]\d\z/,
          /\A429496729[0-5]\z/,
  ]
]
