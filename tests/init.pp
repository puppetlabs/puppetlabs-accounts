node default {
  notify { 'alpha': }
  ->
  class { 'accounts':
    data_store     => 'namespace',
    data_namespace => 'accounts::data',
  }
  ->
  notify { 'omega': }
}
