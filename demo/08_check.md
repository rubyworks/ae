## Check Ok/No

The Check library is an optional library that can be used
to conveniently speed-up construction of reptitive assertions.

To use it, first require the library, then include the mixin
into the namespace in which you will utilize it.

    require 'ae/check'

    include AE::Check

Now we can define ok/no check procedures. A one-off procedure is
defined with a block only.

    check do |x, y|
      x == y
    end

    ok 1,1
    no 1,2

To define reusable check procedures, give the procedure a name.

    check :palindrome do |x|
      x.reverse == x
    end

This will also cause the current check method to be set.
Later in the code, the check procedure can be reset to this
by just passing the name.

    check :palindrome

    ok 'abracarba'
    no 'foolishness'

The Check mixin comes preloaded with a few standard checks.
By default the `:equality` procedure is used.

    check :equality

    ok 1=>1.0

Notice the use of the hash argument here. This is a useful construct for
many check procedures becuase it it akin to the `#=>` pattern we often
see in code examples and it also allows for multiple assertions in one call.
For instance, in the case of `:equality`, multiple entries convey a
meaning of logical-or.

    ok 1=>2, 1=>1

This would pass becuase the second assertion of equality is true.

Another built in check is `:case_equality` which uses `#===` instead of `#==`
to make the comparison.

    check :case_equality

    ok 1=>Integer

