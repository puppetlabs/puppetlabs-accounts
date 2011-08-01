node default {
  notify { 'alpha': }
  ->
  class { 'accounts':
    data_store => 'namespace'
  }
  ->
  notify { 'omega': }
}
