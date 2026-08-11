source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  git_url_regex = %r{\A(?<url>(https?|git)[:@][^#]*)(#(?<branch>.*))?}
  file_url_regex = %r{\Afile:\/\/(?<path>.*)}

  if place_or_version && (git_url = place_or_version.match(git_url_regex))
    [fake_version, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_version && (file_url = place_or_version.match(file_url_regex))
    ['>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

group :development do
  gem "json", '= 2.6.1',                         require: false if Gem::Requirement.create(['>= 3.1.0', '< 3.1.3']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.6.3',                         require: false if Gem::Requirement.create(['>= 3.2.0', '< 4.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "racc", '~> 1.4.0',                        require: false if Gem::Requirement.create(['>= 2.7.0', '< 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "deep_merge", '~> 1.2.2',                  require: false
  gem "voxpupuli-puppet-lint-plugins", '~> 7.0', require: false
  gem "facterdb", '~> 2.1',                      require: false if Gem::Requirement.create(['< 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "facterdb", '~> 3.0',                      require: false if Gem::Requirement.create(['>= 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "metadata-json-lint", '~> 4.0',            require: false
  gem "json-schema", '< 5.1.1',                  require: false
  gem "rspec-puppet-facts", '~> 4.0',            require: false if Gem::Requirement.create(['< 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "rspec-puppet-facts", '~> 5.0',            require: false if Gem::Requirement.create(['>= 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "dependency_checker", '~> 1.0.0',          require: false
  gem "parallel_tests", '= 3.12.1',              require: false
  gem "pry", '~> 0.10',                          require: false
  gem "simplecov-console", '~> 0.9',             require: false
  gem "puppet-debugger", '~> 1.6',               require: false
  gem "rubocop", '~> 1.50.0',                    require: false
  gem "rubocop-performance", '= 1.16.0',         require: false
  gem "rubocop-rspec", '= 2.19.0',               require: false
  gem "rb-readline", '= 0.5.5',                  require: false, platforms: [:mswin, :mingw, :x64_mingw]
  gem "bigdecimal", '< 3.2.2',                   require: false, platforms: [:mswin, :mingw, :x64_mingw]
end
group :development, :release_prep do
  gem "puppet-strings", '~> 4.0',         require: false
  # TODO(puppet-9-support): temporary — voxpupuli-puppet-lint-plugins ~> 7.0 (above) needs
  # puppet-lint ~> 5.1, which conflicts with the released puppetlabs_spec_helper ~> 8.0's
  # puppet-lint ~> 4.0 requirement. puppet-lint 5.x support merged to puppetlabs_spec_helper
  # main in puppetlabs/puppetlabs_spec_helper#485 but hasn't shipped in a release yet (latest
  # is v8.0.0). Swap back to a released '~> 8.x' (or newer) gem once one contains that commit.
  gem "puppetlabs_spec_helper", git: 'https://github.com/puppetlabs/puppetlabs_spec_helper.git', branch: 'main', require: false
  gem "puppet-blacksmith", '~> 7.0',      require: false
end
group :system_tests do
  # TODO(puppet-9-support): temporary — --collection-platform-exclude support for
  # matrix_from_metadata_v3 (keeps a platform in the Puppet 8 acceptance lane while dropping
  # it from Puppet 9, e.g. redhat-7) merged to puppet_litmus main in puppetlabs/puppet_litmus#627
  # but hasn't shipped in a release yet (latest is v2.7.0). Swap back to a released '~> 2.x'
  # gem once a version containing that commit ships.
  gem "puppet_litmus", git: 'https://github.com/puppetlabs/puppet_litmus.git', branch: 'main', require: false, platforms: [:ruby, :x64_mingw]
  gem "CFPropertyList", '< 3.0.7', require: false, platforms: [:mswin, :mingw, :x64_mingw]
  gem "serverspec", '~> 2.41',     require: false
end

gems = {}
puppet_version = ENV.fetch('PUPPET_GEM_VERSION', nil)
facter_version = ENV.fetch('FACTER_GEM_VERSION', nil)
hiera_version = ENV.fetch('HIERA_GEM_VERSION', nil)

# If PUPPET_FORGE_TOKEN is set then use authenticated source for both puppet and facter, since facter is a transitive dependency of puppet
# Otherwise, do as before and use location_for to fetch gems from the default source
if !ENV['PUPPET_FORGE_TOKEN'].to_s.empty?
  # The Puppet 9 stream (8.99.x pre-releases) is served from a source injected via the
  # PUPPET_GEM_SOURCE env var (a CI secret / local export) so no internal host is committed
  # here; it defaults to the public puppetcore source. A plain '~> 8.99' skips prereleases and
  # matches nothing, so honour an exact PUPPET_GEM_VERSION when given, else use a
  # prerelease-aware range that resolves the newest 8.99.x build. facter uses the same source.
  if puppet_version.to_s.match?(/\A(?:~>\s*)?(?:8\.99|9)/)
    puppet9_source = ENV['PUPPET_GEM_SOURCE'].to_s.empty? ? 'https://rubygems-puppetcore.puppet.com' : ENV['PUPPET_GEM_SOURCE']
    puppet9_req = puppet_version.to_s.match?(/\d+\.\d+\.\d/) ? [puppet_version] : ['>= 8.99.0.a', '< 9']
    gems['puppet'] = [*puppet9_req, { require: false, source: puppet9_source }]
    gems['facter'] = ['>= 4.11', { require: false, source: puppet9_source }]
  else
    gems['puppet'] = ['~> 8.11', { require: false, source: 'https://rubygems-puppetcore.puppet.com' }]
    gems['facter'] = ['~> 4.11', { require: false, source: 'https://rubygems-puppetcore.puppet.com' }]
  end
else
  gems['puppet'] = location_for(puppet_version)
  gems['facter'] = location_for(facter_version) if facter_version
end

gems['hiera'] = location_for(hiera_version) if hiera_version

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end
# vim: syntax=ruby
