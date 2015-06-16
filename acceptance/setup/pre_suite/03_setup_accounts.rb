
step "Removing accounts and groups that are used in the accounts tests"

master.user_absent('arthur')
master.group_absent('arthur')
