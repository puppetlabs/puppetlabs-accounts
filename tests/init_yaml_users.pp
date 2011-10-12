node default {
  notify { 'alpha': }
  ->
  class  { 'pe_accounts':
    data_store    => 'yaml',
    manage_groups => false,
  }
  ->
  notify { 'omega': }
}
