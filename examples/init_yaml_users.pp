node default {
  notify { 'alpha': }
  ->
  class  { 'accounts':
    data_store    => 'yaml',
    manage_groups => false,
  }
  ->
  notify { 'omega': }
}
