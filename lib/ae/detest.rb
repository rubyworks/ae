require 'ae/assertion'

class AE

  # Given that x is "tom" then we can assert it
  # is using an asseretion pipe.
  #
  #  x = "tom"
  #
  #  T x == "tom"
  #
  # We can assert the opposite using F.
  #
  #  F x == "tom"
  #
  # These can be used at any point of return.
  #
  #  T case x
  #     when 'tom' then true
  #     else false
  #     end
  #
  module Detest

    # Test for true.
    #
    #   T 1 == 1
    #
    def T(x=nil, &b)
      Assertion.test(x || b.call, :backtrace=>caller)
    end

    # Test for not.
    #
    #   F 1 == 2
    #
    def F(x=nil, &b)
      Assertion.test(!(x || b.call), :backtrace=>caller)
    end

    # Test for nil?.
    #
    #   N nil
    #
    def N(x=nil,&b)
      Assertion.test(nil == (x || b.call), :backtrace=>caller)
    end

    # Expect and error.
    #
    #   E { raise }
    #
    # Unless #T, #F and #N, the #E method only supports block notation.
    def E(&b)
      expect(Exception, &b)
    end

    # Catch a symbol.
    #def C
    #end

  end

end

#class ::Object #:nodoc:
#  include AE::Detest
#end
