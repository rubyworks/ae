# Subjunctives

Okay. I can hear the BDDers rumbling, "where's the *should?*"
AE has nothing against "should", but there are different
approaches for utilizing should nomenclature in specifications,
and AE wants to be open to these techniques. One of which
is how Shoulda (http://shoulda.rubyforge.org) utilizes
`should` in a way analogous to RSpec's use of `it`.

Even so, AE provides an optional mixin called `Subjunctive` which
can be used to create assertor methods with English subjunctive
terms, such as `should`, or `must`, `shall` and `will`.
To load this library use:

    require 'ae/subjunctive'

Then all that is required it to define a subjunctive method for all
objects. For example:

    def will(*args, &block)
      Assertor.new(self, :backtrace=>caller).be(*args,&block)
    end

It's that easy. Because of their commonality AE provides two such terms,
`should` and +must+ as optional add-ons out-of-the-box.

    require 'ae/should'
    require 'ae/must'

We will use these two methods interchangeable for the rest of this
demonstration, but to be clear they both work exactly the same way,
and almost exactly like `assert`.

Keep in mind, AE "conical" functionality does not entail the subjunctive
forms. These are simply options you can load via your `test_helper.rb`,
or similar script, if you prefer these nomenclatures.


## Fluent Notation and Antonyms

Like `assert`, `should` and `must` can be used as higher order functions.

    4.should == 4
    4.must   == 4

Antonyms provided for +should+ as `should!` (read "should not") and `shouldnt`.
For `must`, they are `must!` and +wont+.

    4.should!  == 5
    4.shouldnt == 5

    4.must! == 5
    4.wont  == 5


## To Be

On occasions where the English readability of a specification is hindered,
`be` can be used.

    StandardError.must.be.raised? do
      unknown_method
    end

The `be` method is the same as `assert` with the single exception
that it will compare a lone argument to the receiver using `equate?`,
unlike `assert` which simply checks to see that the argument evaluates
as true.

    10.should.be 10
    10.should.be 10.0
    10.should.be Numeric

    Assertion.assert.raised? do
      10.should.be "40"
    end


## Indefinite Articles

Additional English forms are `a` and `an`, equivalent to `be` except
that they use `case?` (same as `#===`) instead of `equate?` when
acting on a single argument.

    "hi".must.be.a String

    Assertion.assert.raised? do
      /x/.must.be.a /x/
    end

Otherwise they are interchangeable.

    "hi".must.be.an.instance_of?(String)

The indefinite articles work well when a noun follows as an arguments.

    palindrome = lambda{ |x| x == x.reverse }

    "abracarba".must.be.a palindrome

