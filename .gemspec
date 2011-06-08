--- !ruby/object:Gem::Specification 
name: ae
version: !ruby/object:Gem::Version 
  prerelease: 
  version: 1.7.4
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-06-08 00:00:00 Z
dependencies: 
- !ruby/object:Gem::Dependency 
  name: ansi
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :runtime
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: redline
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id002
- !ruby/object:Gem::Dependency 
  name: qed
  prerelease: false
  requirement: &id003 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id003
description: Assertive Expressive is an assertions library specifically designed for reuse by other test frameworks.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- qed/01_overview.rdoc
- qed/02_assertion.rdoc
- qed/03_assert.rdoc
- qed/04_subjunctive.rdoc
- qed/05_expect.rdoc
- qed/06_counts.rdoc
- qed/07_matchers.rdoc
- lib/ae/adapter.rb
- lib/ae/adapters/minitest.rb
- lib/ae/adapters/rspec.rb
- lib/ae/adapters/testunit.rb
- lib/ae/assert.rb
- lib/ae/assertion.rb
- lib/ae/assertor.rb
- lib/ae/basic_object.rb
- lib/ae/check.rb
- lib/ae/core_ext/exception.rb
- lib/ae/core_ext/helpers.rb
- lib/ae/core_ext.rb
- lib/ae/expect.rb
- lib/ae/legacy.rb
- lib/ae/must.rb
- lib/ae/ok.rb
- lib/ae/pry.rb
- lib/ae/should.rb
- lib/ae/subjunctive.rb
- lib/ae/version.rb
- lib/ae.rb
- lib/ae.yml
- HISTORY.rdoc
- APACHE2.txt
- README.rdoc
- NOTICE.rdoc
homepage: http://rubyworks.github.com/ae
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- AE API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
requirements: []

rubyforge_project: ae
rubygems_version: 1.8.2
signing_key: 
specification_version: 3
summary: Assertive Expressive
test_files: []

