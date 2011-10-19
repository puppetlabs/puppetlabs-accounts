node default {
  notify { 'alpha': }
  ->
  class  { 'pe_accounts':
    data_store => 'yaml',
  }
  ->
  notify { 'omega': }
}
