require 'ae/assertion'

module AE

  # = Expect
  #
  #   "When love and skill work together, expect a masterpiece."
  #                                 --John Ruskin (1819 - 1900)
  #
  module Expect

    # The #expect method is a powerful tool for defining
    # expectations in your specifications.
    #
    # Like #should it can be used to designate an expectation
    # via a *functor*.
    #
    #   4.expect == 3
    #
    # Or it can be used in block form.
    #
    #   expect(4){ 3 }
    #
    # This compares the expected value and the actual
    # value with <i>broad equality</i>. This is similar to
    # case equality (#===) but also checks other forms of
    # equality. See the #equate method.
    #
    # Of particluar utility is that #expect allows one to
    # specify if the block raises the error.
    #
    #   expect NoMethodError do
    #     not_a_method
    #   end
    #
    def expect(exp=NoArgument, &block)
      if NoArgument==exp and !block
        return Assertion::Assertor.new(self, :backtrace=>caller)
      end
      if block
        exp = self if NoArgument == exp
        if Exception >= exp
          begin
            r = block.call
            t = exp.equate?(res)
            m = "#{exp}.equate? #{res}"
          rescue exp => error
            t = true
          rescue Exception => error
            t = false
            m = "#{exp} expected but #{error.class} was raised"
          end
        else
          r = block.call
          t = exp.equate?(r)
          m = "#{exp}.equate? #{r}"
        end
      else
        t = exp.equate?(self)
        m = "#{exp}.equate? #{self}"
      end
      raise Assertion.new(m, :backtrace=>caller) unless t
    end

    # Designate a negated expectation. Read this as
    # "expect not".
    #
    #   4.expect! == 4  #=> Expectation Error
    #
    # See #expect.
    #
    # Note that this method would not be necessary if
    # Ruby would allow +!=+ to be defined as a method,
    # or perhaps +!+ as a unary method.
    #
    def expect!(exp=Assertion::Assertor, &block)
      if Assertion::Assertor==exp and !block
        return Assertion::Assertor.new(self, :negate=>true, :backtrace=>caller)
      end
      if block
        exp = self if Expectation == exp
        if Exception === exp # no argument
          begin
            r = block.call
            t = !exp.equate?(res)
            m = "! #{exp}.equate? #{res}"
          rescue exp => error
            t = false
            msg  = "#{exp} raised"
          rescue Exception => error
            t = true
            #m = "#{exp} expected but #{error.class} was raised"
          end
        else
          r = block.call
          t = !exp.equate?(r)
          m = "! #{exp}.equate? #{r}"
        end
      else
        t = !exp.equate?(self)
        m = "! #{exp}.equate? #{self}"
      end
      raise Assertion.new(m, :backtrace=>caller) unless t
    end

    # See #expect! method.
    #
    alias_method :expect_not, :expect!

  end

end

class ::Object #:nodoc:
  include AE::Expect
end
