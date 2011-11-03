require 'ae/subjunctive'

module AE

  # Should
  #
  #   "Always and never are two words you should always
  #    remember never to use."
  #                              --Wendell Johnson
  #
  # @note THIS IS AN OPTIONAL LIBRARY.
  module Should
    # Make an assertion in subjunctive tense.
    #
    #   4.should == 3  #=> Assertion Error
    #
    #   4.should do
    #     self == 4
    #   end
    #
    # @return [Assertor] Assertion functor.
    def should(*args, &block)
      Assertor.new(self, :backtrace=>caller).be(*args, &block)
    end

    # Same as 'object.should == other'.
    #
    # @return [Assertor] Assertion functor.
    def should=(cmp)
      Assertor.new(self, :backtrace=>caller).assert == cmp
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "should not".
    #
    #   4.should! = 4  #=> Assertion Error
    #
    # @return [Assertor] Assertion functor.
    def should!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not.be(*args, &block)
    end

    # NOTE: It would be nice if their were a single term that
    # meant the opposite of should, rather than a two word compound.

    # Alias for #should! method.
    alias_method :should_not, :should!

    # Alias for #should! method.
    alias_method :shouldnt, :should!
  end

end

class ::Object #:nodoc:
  include AE::Should
end

# Copyright (c) 2008 Thomas Sawyer, Rubyworks
