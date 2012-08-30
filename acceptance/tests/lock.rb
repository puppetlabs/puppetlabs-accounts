
test_name 'A locked user should have a nologin shell (or equivalent)'

step 'Creating locked account'

apply_manifest_on(master, "pe_accounts::user {'arthur':
  ensure => present,
  locked => true
}")

nologin_shell = case master['platform']
                  when /debian/, /ubuntu/
                    '/usr/sbin/nologin'
                  when /solaris/
                    '/usr/bin/false'
                  else
                    '/sbin/nologin'
                end

on master, 'getent passwd arthur' do
  fail_test('a login shell was detected') unless result.output.include? nologin_shell
end
