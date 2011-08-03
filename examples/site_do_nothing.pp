# The accounts module manages only sudoers rules
# by default.  No groups or users are created.
node default {
  class { 'accounts': }
}
