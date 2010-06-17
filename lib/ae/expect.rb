require 'ae/assertion'

module AE

  # = Expect
  #
  #   "When love and skill work together, expect a masterpiece."
  #                                 --John Ruskin (1819 - 1900)
  #
  module Expect

    # The #expect method is a convenient tool for defining
    # certain sets of expectations in your specifications.
    #
    # Expect is used to expect a result from a block of code.
    # If the argument to expect is a subclass of Exception
    # or instance thereof, then the block is monitored for
    # the raising of such an exception.
    #
    #   expect StandardError do
    #     raise ArgumentError
    #   end 
    #
    # All other expectations are compared using case equality (#===). 
    # This allows one to verify matching Regexp.
    #
    #   expect /x/ do
    #     "x"
    #   end 
    #
    # As well as checking that an object is an instance of a given Class.
    #
    #   expect String do
    #     "x"
    #   end 
    #
    # Like #assert it can be used to designate an expectation
    # via a *functor*.
    #
    #   4.expect == 3
    #
    def expect(*args, &block)
      Assertor.new(self, :backtrace=>caller).expect(*args, &block)
    end

    # Designate a negated expectation. Read this as "expect not".
    #
    # See #expect.
    #
    def expect!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not.expect(*args, &block)
    end

    # Alias for #expect! method.
    alias_method :forbid, :expect!

    # Like #expect but uses the reciever as the object
    # of expectation.
    #
    #   /x/.expected do
    #     "oooxooo"
    #   end
    #
    def expected(*args, &block)
      expect(self, *args, &block)
    end

  end

end#module QED

class ::Object #:nodoc:
  include AE::Expect
end

