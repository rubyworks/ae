# Assertive Expressive

[Website](http://rubyworks.github.com/ae) /
[API](http://rubydoc.info/gems/ae) /
[User Guide](http://wiki.github.com/rubyworks/ae) /
[Report Issue](http://github.com/rubyworks/ae/issues) /
[Source Code](http://github.com/rubyworks/ae)

[![Gem Version](https://badge.fury.io/rb/ae.png)](http://badge.fury.io/rb/ae)
[![Build Status](https://secure.travis-ci.org/rubyworks/ae.png)](http://travis-ci.org/rubyworks/ae) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)


## About

Assertive Expressive (AE) is an assertions framework
intended for reuse by any TDD, BDD or similar system.


## Features

* Clear, simple and concise syntax.
* Uses higher-order functions and fluid notation.
* Reusable core extensions ease assertion construction.
* Core extensions are standardized around Ruby Facets.
* But Facets is not a dependency; the extensions are built-in.
* Easily extensible allowing for alternate notations.
* Eats it's own dog food.


## Synopsis

AE defines the method `assert`. It's is compatible with the method
as defined by Test::Unit and MiniTest, which verifies truth of a
single argument (and can accept an optional failure message).

    assert(true)

In addition AE's `assert` method has been extended to accept a block,
the result of which is likewise verified.

    assert{true}

But the real power the AE's +assert+ method lies in it's use
without argument or block. In that case it returns an instance of
`Assertor`. An `Assertor` is an *Assertions Functor*, or 
*Higher-Order Function*. It is a function that operates on
another function. With it, we can make assertions like so:

    x.assert == y

    a.assert.include? e

    StandardError.assert.raised? do
      ...
    end

And so forth. Any method can be used in conjunction with +assert+
to make an assertion. Eg.

    class String
      def daffy?
        /daffy/i =~ self
      end
    end

    "Daffy Duck".assert.daffy?

When an assertion fails an Assertion exception is raised. Any test
framework can catch this exception and process it accordingly.
Technically the framework should check to see that the exception
object responds affirmatively to the #assertion? method. This way any
type of exception can be used as a means of assertion, not just AE's
Assertion class.

Please have a look at the QED and API documentation to learn more.


## Integration

Generally speaking, AE can be used with any test framework simply by putting
`require 'ae'` in a test helper script. However to fully
integrate with a test framework and ensure the test framework recognizes
AE assertions (as more than just exceptions) and to ensure assertion
counts are correct, a little extra interfacing code may be necessary.

Lucky for you AE has already done the leg work for the most common
test frameworks:

    require 'ae/adapters/testunit'
    require 'ae/adapters/minitest'
    require 'ae/adapters/rspec'

(Note that Cucumber does not need an adapter.)

AE also includes a script that will automatically detect the current
test framework by checking for the existence of their respective 
namespace modules.

    require 'ae/adapter'


## Nomenclature

With AE, defining assertions centers around the #assert method. So
*assert* can be thought of as AE's primary _nomenclature_. However, variant
nomenclatures have been popularized by other test frameworks, in particular
*should* and *must*. If you prefer one of them terms, AE provides optional
libraries that can loaded for utilizing them.

    require 'ae/should'
    require 'ae/must'

By loading one of these scripts (or both) into your test system (e.g. via a test
helper script) you gain access to subjunctive terminology. See the API documentation
for the Subjunctive module for details.


## Legacy

To ease transition from TestUnit style assertion methods, AE provides
a TestUnit legacy module.

    require 'ae/legacy'

This provides a module `AE::Legacy::Assertions` which is included in AE::World
and can be mixed into your test environment to provide old-school assertion
methods, e.g.

    assert_equal(foo, bar, "it failed")


## Installation

### Gem Installs

Install AE in the usual fashion:

    $ gem install ae

### Site Installs

Local installation requires Setup.rb.

    $ gem install setup

Then download the tarball package from GitHub
and do:

    $ tar -xvzf ae-1.0.0.tgz
    $ cd ae-1.0.0.tgz
    $ sudo setup.rb all

Windows users use 'ruby setup.rb all'.


## Contributing

If you would like to contribute code to the AE project, for the upstream
repository and create a branch for you changes. When your changes are ready
for review (and no, they do not have to 100% perfect if you still have some issues
you need help working out).

It you need to personally discuss some ideas or issue you try to get up with us
via the mailing list or the IRC channel.

* [Source Code](http://github.com/rubyworks/ae) /
* [IRC Channel](irc://irc.freenode.net/rubyworks) /
* [Mailing List](http://googlegroups.com/group/rubyworks-mailinglist)


## Copyrights & License

Copyright (c) 2008 Rubyworks. All rights reserved.

Unless otherwise provided for by the originating author, this
program is distributed under the terms of the *BSD-2-Clause* license.
Portions of this program may be copyrighted by others.

See the NOTICE.rdoc file for details.

AE is a [Rubyworks](http://rubyworks.github.com) project.

