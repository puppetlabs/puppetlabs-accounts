node default {
  notify { 'alpha': }
  ->
  class  { 'accounts':
    data_store => 'yaml',
  }
  ->
  notify { 'omega': }
}
