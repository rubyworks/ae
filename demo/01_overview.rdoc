= AE Overview

Require the library with default nomenclatures.

  require 'ae'

This provides +assert+, +expect+ and +should+.
As we can see all three work the same when used
fluidly (ie. magic-dot notation).

  1.assert == 1
  1.expect == 1
  1.should == 1

If the operation returns false or nil, the an Assertion exception
is raised.

  Assertion.assert.raised? do
    1.assert == 2
    1.expect == 2
    1.should == 2
  end

== Assert

The #assert method can check that an argument evaluates to true.
returned by a block.

  assert(true)

  Assertion.assert.raised? do
    assert(false)
  end

The #assert method can also compare an argument to the value
returned by a block with #==.

  assert(3) do
    3
  end

  Assertion.assert.raised? do
    assert(3) do
      4
    end
  end


== Expect

Expect will comapre...

  expect(self)

Expect uses #equate? for comparison. +equate?+ can be thought of
as "broad equality". It is defined as:

  def equate?(x)
    equal?(x) || eq?(x) || self == x || self === x
  end

So providing an argument and a block to +expect+ we can test for braod
range of comparsion. For example we can test for subclass.

  expect(Numeric) do
    3
  end

If an Exception is provided, expect will test to see if the block
raises an error.

  expect(StandardError) do
    some_undefined_method
  end

  expect(Assertion) do
    expect(nil)
  end

  Assertion.assert.raised? do
    expect(Numeric) do
      "3"
    end
  end


== Should

Should is a subjunctive assertion method. It allows one to easily
specify an assertion message to a blocc that must pass (ie. return
value other than false or nil).

  should "be true" do
    true
  end

  Assertion.assert.raised? do
    should "be true" do
      false
    end
  end


QED.

