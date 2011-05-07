--- 
spec_version: 1.0.0
replaces: []

loadpath: 
- lib
name: ae
repositories: 
  public: git://github.com/rubyworks/ae.git
conflicts: []

engine_check: 
- ruby 1.8.7 (2010-08-16 patchlevel 302) [x86_64-linux]
- ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-linux]
title: AE
contact: trans <transfire@gmail.com>
resources: 
  code: http://github.com/rubyworks/ae
  mail: http://groups.google.com/group/rubyworks-mailinglist
  docs: http://wiki.github.com/rubyworks/ae/docs/qed
  wiki: http://wiki.github.com/rubyworks/ae
  bugs: http://github.com/rubyworks/ae/issues
  home: http://rubyworks.github.com/ae
maintainers: []

requires: 
- group: 
  - build
  name: redline
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
manifest: MANIFEST
version: 1.7.1
licenses: 
- Apache 2.0
copyright: Copyright (c) 2008 Thomas Sawyer
authors: 
- Thomas Sawyer
organization: Rubyworks
description: Assertive Expressive is an assertions library specifically designed for reuse by other test frameworks.
summary: Assertive Expressive
created: 2008-08-17
