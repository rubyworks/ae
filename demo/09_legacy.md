# Legacy Assertions

The optional `ae/legacy` library provides Test::Unit's assertion
methods, for an easier move from Test::Unit to AE. They are defined
in the `AE::Legacy::Assertions` module, which `AE::World` includes.

    require 'ae/legacy'

    class LegacyTest
      include AE::Legacy::Assertions
    end

    t = LegacyTest.new


## Assert

With an argument, `assert` checks that it is true, with an optional
message.

    t.assert(true)
    t.assert(1 == 1, "one is one")

    Assertion.assert.raised? do
      t.assert(false, "must fail")
    end

    Assertion.assert.raised? do
      t.assert(nil)
    end

With a block instead, it works like `assert_block`.

    t.assert { true }

    Assertion.assert.raised? do
      t.assert { false }
    end


## Assert Block

    t.assert_block { true }

    Assertion.assert.raised? do
      t.assert_block { false }
    end


## Equality and Type

    t.assert_equal 2, 1 + 1

    Assertion.assert.raised? do
      t.assert_equal 2, 3
    end

`assert_instance_of` wants the exact class, while `assert_kind_of`
accepts a superclass too.

    t.assert_instance_of Integer, 1
    t.assert_kind_of Numeric, 1

    Assertion.assert.raised? do
      t.assert_instance_of Numeric, 1
    end


## Raises

`assert_raises` passes if the block raises one of the given exceptions,
or a subclass of one, and returns the exception.

    e = t.assert_raises(ArgumentError) { raise ArgumentError, "bad" }
    e.message.assert == "bad"

    t.assert_raises(StandardError) { raise ArgumentError }

It fails if nothing is raised, or something else is.

    Assertion.assert.raised? do
      t.assert_raises(ArgumentError) { }
    end

    Assertion.assert.raised? do
      t.assert_raises(ArgumentError) { raise TypeError }
    end


## Throws

    t.assert_throws(:done) { throw :done }

    Assertion.assert.raised? do
      t.assert_throws(:done) { throw :other }
    end

    Assertion.assert.raised? do
      t.assert_throws(:done) { }
    end


## Messages

Each assertion has a default message.

    message = begin
      t.assert_operator 1, :>, 2
    rescue Assertion => e
      e.message
    end

    message.assert.include?("Expected 1.>(2) to be true")


## Counts

Legacy assertions are counted like any other.

    before = AE::Assertor.counts[:total]
    t.assert_equal 1, 1
    AE::Assertor.counts[:total].assert == before + 1
