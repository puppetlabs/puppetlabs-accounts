plan accounts::provision_machines(
  Optional[String] $pe_master = 'centos-7-x86_64',
  Optional[String] $agent = 'centos-7-x86_64',
) {
  # provision server machine, set role
  run_task('provision::abs', 'localhost', action => 'provision', platform => $pe_master, inventory => './', vars => 'role: master')
  run_task('provision::abs', 'localhost', action => 'provision', platform => $agent, inventory => './', vars => 'role: agent')
}