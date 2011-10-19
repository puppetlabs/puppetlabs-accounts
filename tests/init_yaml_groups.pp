node default {
  notify { 'alpha': }
  ->
  class  { 'pe_accounts':
    manage_users => false,
    data_store   => 'yaml',
  }
  ->
  notify { 'omega': }
}
