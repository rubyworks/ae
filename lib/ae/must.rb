module AE
  require 'ae/subjunctive'

  # Must
  #
  #   "It is not enough to succeed. Others must fail."
  #                           --Gore Vidal (1925 - )
  #
  # THIS IS AN OPTIONAL LIBRARY.
  #
  module Must
    # The #must method is functionaly the same as #should.
    #
    # @example
    #   4.must == 3  #=> Assertion Error
    #
    # @example
    #   4.must do
    #     self == 4
    #   end
    #
    # @return [Assertor] Assertion functor.
    def must(*args, &block)
      Assertor.new(self, :backtrace=>caller).be(*args, &block)
    end

    # Same as 'object.must == other'.
    #
    # @return [Assertor] Assertion functor.
    def must=(cmp)
      Assertor.new(self, :backtrace=>caller) == cmp
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "must not".
    #
    # @example
    #   4.must! == 4  #=> Assertion Error
    #
    # @return [Assertor] Assertion functor.
    def must!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not.be(*args, &block)
    end

    # Perhaps not literally the counter-term to *must* (rather *will*),
    # it is close enough for our purposes and conveys the appropriate
    # semantics, and I think is more sightly than *mustnt*.
    #
    # This method may be deprecated in the future when Ruby 1.9 becomes
    # mainstream, as it allows for redefining *#!* as a method.
    alias_method :wont, :must!

    # Alias for #must! method.
    #alias_method :musnt   , :must!
  end

end

class ::Object #:nodoc:
  include AE::Must
end

# Copyright (c) 2008 Thomas Sawyer
