plan accounts::puppet_agents_setup(
) {
  # get pe_server ?
  $server = get_targets('*').filter |$n| { $n.vars['role'] == 'master' }

  # get agents ?
  $agents = get_targets('*').filter |$n| { $n.vars['role'] != 'master' }

  # install agents
  run_task('puppet_agent::install', $agents)

  # set the server
  $server_string = $server[0].name
  run_task('puppet_conf', $agents, action => 'set', section => 'main', setting => 'server', value => $server_string)
}