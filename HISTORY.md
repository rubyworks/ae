# RELEASE HISTORY

## 1.9.1 / 2026-11-10

This release fixes assertions that checked nothing, or less than they
appeared to. So some tests that passed before may now fail, but each
of those was not checking what it said.

Changes:

* Fix `x.assert.equal?(y)`, which always passed. Ruby's BasicObject,
  Assertor's superclass, has its own public `equal?`, so the call
  never became an assertion. Now it does, like `==`, `!=` and `!`.
* `x.assert.instance_eval { ... }` and `instance_exec` go to the
  object, so the block's result is the assertion. They used to run in
  the Assertor and check nothing.
* Warn about `x.assert.size == 3`, which checks only that `size` is
  truthy. The warning comes when a method called with no arguments
  returns something other than true, false or nil. Write
  `x.size.assert == 3` instead.
* Pass keyword arguments on as keywords.
* `assert(expected) { ... }` and `expect(expected) { ... }` compare
  with any expected value, including `false` and `nil`.
* A Hash or Symbol is no longer used as a proc because it has
  `#to_proc`, so `refute({a: 1})` fails. A lambda that takes no
  arguments works as a matcher.
* Fix `flunk`, which raised NoMethodError, and passed when negated.
* Fix `expect` with a block that takes the receiver, and with an
  exception instance. It no longer catches an interrupt or an exit.
* Fix the legacy Test::Unit assertions: `assert(false)` never failed,
  `assert_block` was inverted, `assert_raises` and `assert_throws`
  were broken, and `assert_instance_of` accepted a subclass. They are
  counted now, and raise the test framework's assertion error.
* The minitest and test-unit adapters add AE's assertions to the
  test's count, and `ae/adapter` finds current minitest, which no
  longer defines `MiniTest`.
* Build failure messages only for failures. A passing `==` on two
  1000-element arrays took five seconds. A broken `#inspect` no
  longer breaks the message, and very large color diffs are skipped.
* Color diffs are on only when standard output is a terminal and
  NO_COLOR is not set. `AE.ansi = true` or `false` still decides.
* `Kernel#pry` no longer caches, which mixed up equal objects and
  kept them all alive. It passes keywords, and sends `==` and the
  like to the object.
* Fix `in_epsilon?` for negative numbers, `match?` for objects without
  `=~`, and `throws?`, `thrown?` and `send?`, which hid errors raised
  by the code under test.
* Fix `AE::Check.define` and `Check::Proc#message`, and report a failed
  `ok` or `no` at the line that called it.
* Add demos for the legacy assertions and the adapters, and fix demos
  that asserted nothing.
* Test on Ruby 4.0.


## 1.9.0 / 2026-03-30

Maintenance release. Modernized project tooling and cleaned up documentation.

Changes:

* Replace custom Indexer system with standard gemspec.
* Replace Travis CI with GitHub Actions.
* Replace Assembly/detroit with Rakefile.
* Simplify version.rb to use a plain constant.
* Update minitest adapter for minitest 5+.
* Update testunit adapter for modern test-unit gem.
* Fix typos and update URLs to HTTPS.
* Add LICENSE.txt.
* Move site from gh-pages to docs/.
* Remove obsolete files (var/, etc/, MANIFEST, DEMO.rdoc).
* Clean up .gitignore.


## 1.8.2 / 2013-02-18

This release primarily fixes one bug --the assertions count
global variable wasn't all caps, which prevented assertions
from being counted correctly.

Changes:

* Fix $ASSERTION_COUNTS letter case.


## 1.8.1 / 2011-12-04

Fixed missing ae/ansi.rb file from distribution.

Changes:

* Update manifest, missing ae/ansi.rb


## 1.8.0 / 2011-12-03 / Checkered Flag

This new release improves support for Proc-based assertions and
RSpec-style matchers. In addition, this release sees the optional
Check Ok/No library in a usable state. And, lastly, note the license
has been changed to BSD-2-Clause.

Changes:

* Finalize the Check mixin API.
* Improve Proc and RSpec-style matchers.
* Modernize the build configuration.
* Change licenses to BSD-2-Clause.


## 1.7.4 / 2011-06-08

Quick release fixes an issue due to Ruby 1.9+'s constant look-up
system. Yes, BasicObject has no clue. This is fixed using the
`const_missing` hook.

Changes:

* Add const_missing hook to Assertor class to redirect to 
  toplevel methods.

## 1.7.3 / 2011-06-06 / D-Day

This release simply adds a new optional help library, `ok.rb`.
The API is still in it's infancy, so it probably will change
but this early release can help refine it's development.

Changes:

* Add option `ok` helper library.


## 1.7.2 / 2011-06-02

Minor release adds color diffs for failed equality comparisons to
the error message, and it fixes an issue in which class references
needed the toplevel prefix (`::`) to ensure they can be found in 
all cases. Note that ANSI color diffs can be deactivated via
AE.ansi = false or using the master switch an upcoming release
of the ANSI gem.

Changes:

* Add toplevel prefix (`::`) to class references in assertor.rb.
* Provide ANSI colored diffs for failed equality comparisons.


## 1.7.1 / 2011-05-06

This release adds a specialized message for certain comparison
operators to allow them have a more forensic output. This is done
via ANSI::Diff library. This release also deprecates the optional
dot.rb and detest.rb emulation scripts.

Changes:

* Add special message for comparison assertions.
* Remove optional dot.rb and detest.rb emulation scripts.


## 1.7.0 / 2011-04-28

AE now uses proper namespace for all classes. In particular, the `Assertor`
class has become `AE::Assertor`. Only the `Assertion` class remains outside
the `AE` namespace, as it is now used to map to the current exception class
for raising assertions as defined by current test framework. In addition,
AE's Kernel extensions, which are used to adapt AE for use with any given
test framework have been moved to the AE and AE::Assertor classes as
class methods along with AE's assertion count methods.

Changes:

* All AE classes use proper namespace.
* Framework methods moved to AE::Assertor class.
* Assertion count tracking methods moved to AE::Assertor class.
* AE::Assertion class simplified to a simple subclass of Exception.


## 1.6.1 / 2010-11-05

This release has test passing for Ruby 1.9.2. Ruby 1.9.2 doesn't appear
to like &block and block_given? to be used in same method scope. It
may be a Ruby bug, nonetheless AE has been adjusted to circumvent the
problem.

Changes:

* Use `&block` and not `block_given?`.


## 1.6.0 / 2010-11-04

Support libraries defining toplevel methods, such as `legacy.rb`, now place
their methods in AE::World module instead of Object. AE::World needs to
to be included in the context desired for the testing framework used. This
is important to prevent pollution of the Object namespace.

Changes:

* Toplevel extras are defined in AE::World instead of Object.
* In dot.rb #true/#false methods renamed to `#true!`/`#false!`.
* In dot.rb `#true!`/`#false!` methods can take an error or error message.


## 1.5.0 / 2010-09-06

This release adds adapters for TestUnit, MiniTest and RSpec. AE worked with
them previously but AE assertions were seen as errors rather than nice
assertions. Likewise assertion counts were off in the final tally. These
adapters insert AE's counts so the tally are correct.

In addition to this the Assertion class itself now acts as the final end
point for all assertions, which makes for a very clean interface.

Changes:

* Add adapters for TestUnit, MiniTest and RSpec.
* Move final assertion call to Assertion#test.


## 1.4.0 / 2010-09-02

Version 1.4 brings Ruby 1.9 compatibility. The Assertor class is now a
subclass of BasicObject. This fixes an issues Assertor would had
applying to methods defined both in a class and Kernel.

Changes:

* Assertor is a subclass of BasicObject.
* Use custom BasicObject when using Ruby 1.8.
* Add #assert= which works like `assert ==`.
* Add #refute= which works like `refute ==`.


## 1.3.0 / 2010-06-17

New release of AE adds support for RSpec-style matchers. This means
it should be usable with Shoulda 3.0 and any other matchers library.
This release also cleans up the underlying code, which is now
extremely clean. Lastly a small API change allows #assert to compare
it's argument to the return of it's block using #==, just as #expect
does using #===.

Changes:

* Add RSpec-style matchers support.
* Move #expect code to Assertor.
* #assert method can do equality comparison.


## 1.2.3 / 2010-06-07

This release is a quick fix, which adds a missing `require 'yaml'`.

Changes:

* Add missing require 'yaml'.


## 1.2.2 / 2010-06-06

Version 1.2.2 simply add one new feature --the ability to
use 'object.assert = other' instead of 'object.assert == other'.
This was added simply because I found I often made the mistake
of a missing '=', and since #assert= has no definition, there
was no reason not to have behave accordingly.

Also note that I switched the license from LGPL to MIT.
With regards to reusable libraries and I moving all my
work, such that I am able, to MIT to maximize free usage.

Changes:

* Add `#assert=` method as a shortcut for `#assert ==`.
* Now distributed under MIT license.


## 1.2.0 / 2010-01-27

This release fixes '=~' assertions and now requires the
ae/expect library by default.

Changes:

* Expect method is now loaded by default when requiring 'ae'.
* Fixed bug where #=~ did not work correctly against Assertor.


## 1.1.0 / 2009-09-06

This release provided two major improvements. The first is
the #expect method which is similar to #assert, but uses 
case equality (#===) for comparison. And second, an optional
library `ae/legacy.rb`, is has been added that provides
backward compatibility with Test::Unit assertions, should it
be needed.

Changes:

* New #expect method.
* Proved legacy assertion in optional ae/legacy.rb library.
* Added backtrace parameter to flunk calls.


## 1.0.0 / 2009-09-03

This is the initial release of AE.

Changes:

* Happy Birthday!

