node default {
  notify { 'alpha': }
  ->
  class { 'accounts': }
  ->
  notify { 'omega': }
}
