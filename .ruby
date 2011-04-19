--- 
name: ae
engines_tested: 
- ruby 1.8.7 (2010-01-10 patchlevel 249) [x86_64-linux]
- ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-linux]
spec_version: 1.0.0
title: AE
contact: trans <transfire@gmail.com>
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
resources: 
  repo: git://github.com/rubyworks/ae.git
  code: http://github.com/rubyworks/ae
  mail: http://groups.google.com/group/rubyworks-mailinglist
  docs: http://wiki.github.com/rubyworks/ae/docs/qed
  bugs: http://github.com/rubyworks/ae/issues
  wiki: http://wiki.github.com/rubyworks/ae
  home: http://rubyworks.github.com/ae
suite: rubyworks
manifest: 
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
- lib/ae/core_ext/assert.rb
- lib/ae/core_ext/exception.rb
- lib/ae/core_ext/helpers.rb
- lib/ae/core_ext.rb
- lib/ae/detest.rb
- lib/ae/dot.rb
- lib/ae/expect.rb
- lib/ae/legacy.rb
- lib/ae/must.rb
- lib/ae/pry.rb
- lib/ae/should.rb
- lib/ae/subjunctive.rb
- lib/ae/version.rb
- lib/ae.rb
- lib/ae.yml
- Profile
- README.rdoc
- Syckfile
- History.rdoc
- License.txt
- NOTICE.rdoc
version: 1.6.1
licenses: 
- Apache 2.0
copyright: Copyright (c) 2008 Thomas Sawyer
description: Assertive Expressive is an assertions library specifically designed for reuse by other test frameworks.
summary: Assertive Expressive
authors: 
- Thomas Sawyer
created: 2008-08-17
