require 'ae/subjunctive'

module AE

  # = Should
  #
  #  "Always and never are two words you should always
  #   remember never to use."
  #                              --Wendell Johnson
  #
  # THIS IS AN OPTIONAL LIBRARY.
  #
  module Should
    # Make an assertion in subjunctive tense.
    #
    #   4.should == 3  #=> Assertion Error
    #
    #   4.should do
    #     self == 4
    #   end
    #
    def should(*args, &block)
      Assertor.new(self, :backtrace=>caller).be(*args, &block)
    end

    # Same as 'object.should == other'.
    def should=(cmp)
      Assertor.new(self, :backtrace=>caller).assert == cmp
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "should not".
    #
    #   4.should! = 4  #=> Assertion Error
    #
    def should!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not.be(*args, &block)
    end

    # Not quite the literally the counter-term to *should* (rather *shall*), but
    # it is close enough for our purposes and conveys the appropriate semantics.
    #alias_method :shant, :should!

    # Alias for #should! method.
    alias_method :shouldnt, :should!
  end

end

class ::Object #:nodoc:
  include AE::Should
end

# Copyright (c) 2008,2009 Thomas Sawyer
