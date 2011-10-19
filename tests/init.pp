node default {
  notify { 'alpha': }
  ->
  class { 'pe_accounts':
    data_store     => 'namespace',
    data_namespace => 'pe_accounts::data',
  }
  ->
  notify { 'omega': }
}
