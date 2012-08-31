
step "Removing accounts and groups that are used in the pe_accounts tests"

master.user_absent('arthur')
master.group_absent('arthur')