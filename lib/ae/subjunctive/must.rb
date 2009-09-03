require 'ae/subjunctive'

module AE

  # = Must
  #
  #   "It is not enough to succeed. Others must fail."
  #                           --Gore Vidal (1925 - )
  #
  # THIS IS AN OPTIONAL LIBRARY.
  #
  module Must
    # The #must method is functionaly the same as #should.
    #
    #   4.must == 3  #=> Assertion Error
    #
    #   4.must do
    #     self == 4
    #   end
    #
    def must(*args, &block)
      Assertor.new(self, :backtrace=>caller).be(*args, &block)
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "must not".
    #
    #   4.must! == 4  #=> Assertion Error
    #
    def must!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not(*args, &block)
    end

    # Perhaps not literally the counter-term to *must* (rather *will*),
    # it is close enough for our purposes and conveys the appropriate semantics.
    alias_method :wont, :must!

    # Alias for #must! method.
    #alias_method :musnt   , :must!
  end

end

class ::Object #:nodoc:
  include AE::Must
end

# Copyright (c) 2008,2009 Thomas Sawyer
