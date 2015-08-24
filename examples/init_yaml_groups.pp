node default {
  notify { 'alpha': }
  ->
  class  { 'accounts':
    manage_users => false,
    data_store   => 'yaml',
  }
  ->
  notify { 'omega': }
}
