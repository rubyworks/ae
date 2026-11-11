# Assert Method

## Compatible with Test::Unit

The `assert` method is designed to be backward compatible
with the same method in `Test::Unit`.

Using an argument, `assert` will check that an argument evaluates
to true. Optionally one can send along a meaningful message should
the assertion fail.

    assert(true, "Not true!")

    expect Assertion do
      assert(false, "Not true!")
    end


## Assert with a Block

In addition +assert+ has been extended to accept a block. Like the case of the
argument, the block is expected to return something that evaluates as true.

    assert do
      true
    end

    Assertion.assert.raised? do
      assert do
        false
      end
    end

We should also mention that, while probably not very useful, since
the arity of a block can be checked, one can also pass the receiver
into the block as a block argument.

    "hi".assert do |s|
      /h/ =~ s
    end

Given an argument as well, `assert` compares it to the block's result
using `#==`. Any argument counts, even `false` or `nil`.

    assert(5) { 2 + 3 }
    assert(nil) { nil }

    Assertion.assert.raised? do
      assert(false) { true }
    end


## Antonyms for Assert

We can state the opposite assertion using `assert!`.

    10.assert! == 9

Or, because some people do not like the use of a bang method, +refute+.

    10.refute == 9

These terms can be used just as +assert+ is used in all examples,
but with the opposite inference.

Another way to get the opposite inference, is to use +not+.

    10.assert.not == 9

## Lambda Assertions

Passing  +assert+ a `Proc` object, or any object that responds to `#call`,
will be used as if it were a block. This allows for a simple way to quickly
create reusable assertions.

    palindrome = lambda{ |word| word == word.reverse }

    "abracarba".assert palindrome

A lambda that takes no arguments is called without the receiver.

    "abracarba".assert lambda { true }

The message for a failed assertion will come from calling `#to_s` on the
object.

A Hash or a Symbol is a value like any other, even though each has
`#to_proc`, so here `assert` and `refute` check only that it is truthy.

    assert({a: 1})

    Assertion.assert.raised? do
      refute({a: 1})
    end

## RSpec-style Assertion Matchers

If an object passed to assert responds to `#matches?` then AE will handle
the object as an RSpec-style mather, the receiver will be passed to the
`#matches?` method to determine if the assertion passes and RSpec matcher
message methods will be used if they are defined.

    palindrome = Object.new

    def palindrome.matches?(word)
      word == word.reverse
    end

    "abracarba".assert palindrome


## Identity Assertions

Rather then the general form.

    x = 10
    x.object_id.assert == x.object_id

We can use Ruby's own `equal?`> method.

    x.assert.equal?(x)

It fails for an equal but separate object.

    Assertion.assert.raised? do
      "abc".assert.equal?("abc".dup)
    end

And the opposite.

    x.refute.equal?(11)

    Assertion.assert.raised? do
      x.refute.equal?(x)
    end

AE provides `identical?`> method as an alternative
to make it a bit more clear.

    x.assert.identical?(x)


## Equality Assertions

The most common assertion is that of value equality (`==`),
as we have seen throughout this document. But other forms of
equality can be verified as easily. We have already mentioned 
identity. In addition there is *type equality*.

    17.assert.eql? 17

    Assertion.assert.raised? do
      17.assert.eql? 17.0
    end

And there is *case equality*.

    Numeric.assert === 3


## Checking Equality with a Block

Because operators can not take blocks, and at times blocks can
be convenient means of supplying a value to an assertion,
AE has defined alternate renditions of the equality methods.
For equal? and eql?, the method names are the same, they simply
can take a block in place of an argument if need be.

For *value equality* (`==`), the method is called *eq?*.

    10.assert.eq? do
      10.0
    end

And should it fail,

    Assertion.assert.raised? do
      10.assert.eq? do
        20
      end
    end


## Case Equality

For *case equality* (`===`), it is `case?`.

    Numeric.assert.case? do
      "3".to_i
    end

    Assertion.assert.raised? do
      Numeric.assert.case? do
        "3"
      end
    end


## Regular Expressions

Regular Expressions can be used to make assertions in much the same way as equality.

    /i/.assert =~ "i"

    Assertion.assert.raised? do
      /i/.assert =~ "g"
    end

Conversely the String class recognizes the #=~ method as well.

    "i".assert =~ /i/

    Assertion.assert.raised? do
      "i".assert =~ /g/
    end


## Exception Assertions

Validating errors is easy too, as has already been shown
in the document to verify assertion failures.

    StandardError.assert.raised? do
      unknown_method
    end


## Assertions on Object State

While testing or specifying the internal state of an object is
generally considered poor form, there are times when it is 
necessary. Assert combined with +instance_eval+ makes it easy too.

    class X
      attr :a
      def initialize(a); @a = a; end
    end

    x = X.new(1)

    x.assert.instance_eval do
      @a == 1
    end

    Assertion.assert.raised? do
      x.assert.instance_eval do
        @a == 2
      end
    end


## Catch/Try Assertions

Catch/Try throws can be tested via `Symbol#thrown?`.

    :hookme.assert.thrown? do
      throw :hookme
    end

Alternatively, a lambda containing the potential throw
can be the receiver using `throws?`.

    hook = lambda{ throw :hookme }
  
    hook.assert.throws?(:hookme)


## Assertions on Proc Changes

I have to admit I'm not sure how this is useful,
but I found it in the Bacon API and ported it over
just for sake of thoroughness.

    a = 0

    l = lambda{ a }

    l.assert.change?{ a +=1 }


## Assertion on literal True, False and Nil

Ruby already provides the #nil? method.

    nil.assert.nil?

AE adds `true?` and `false?` which acts accordingly.

    true.assert.true?
    false.assert.false?


## Keyword Arguments

Keyword arguments are passed on to the method as keywords.

    class Gate
      def open?(strict: false)
        !strict
      end
    end

    Gate.new.assert.open?(strict: false)
    Gate.new.refute.open?(strict: true)


## Comparing a Method's Result

A method called on `assert` makes the assertion itself, so its result
can't be compared afterwards. Here `size` returns 2, which is truthy, so
the assertion passes. The comparison with 3 is then made with the
assertion's own result, and checks nothing.

    require 'stringio'
    $stderr, stderr = StringIO.new, $stderr

    [1, 2].assert.size == 3

    warning, $stderr = $stderr.string, stderr

To compare a result, call the method first.

    [1, 2].size.assert == 2

Because this is an easy mistake to make, AE warns when a method called
without arguments returns something other than true, false or nil.

    warning.assert.include?("`size` returned 2")


## Flunk

`flunk` always fails, negated or not.

    Assertion.assert.raised? do
      flunk "not done yet"
    end

    Assertion.assert.raised? do
      10.refute.flunk
    end


## Send Assertions

Assert that a method can be successfully called.

    "STRING".assert.send?(:upcase)


## Numeric Delta and Epsilon

You may wish to assert that a numeric value is with some
range.

    3.assert.in_delta?(1,5)

Or minimum range, relative to the smaller of the two magnitudes.

    3.assert.in_epsilon?(3,5)
    -100.0.assert.in_epsilon?(-100.05, 0.01)

    Assertion.assert.raised? do
      -100.0.assert.in_epsilon?(-101.5, 0.01)
    end


## Verifying Object State

Not surprisingly if underlying object state needs to be verified, +instance_eval+
can be used in conjunction with +assert+.

    class X
      attr :a
      def initialize(a); @a = a; end
    end

    x = X.new(4)

    x.instance_eval do
      @a.assert == 4
    end

Calling #instance_eval on #assert works too, as shown under "Assertions
on Object State" above: the block runs in the object, and its result
is the assertion.

    Assertion.assert.raised? do
      x.assert.instance_eval do
        @a == "obviously wrong"
      end
    end

AE offers an optional helper method for times when testing underlying private
or protected methods is important, called #pry. See the QED on pry for more
information.

For some testing underlying implementation might be considered poor
form. You will get no argument here. It should be used thoughtfully,
but I would not bet against there being occasions when such validations
might be needed.

