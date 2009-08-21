require 'ae/assertion'

module AE

  # = Must
  #
  #   "It is not enough to succeed. Others must fail."
  #                           --Gore Vidal (1925 - )
  #
  # The term *must* is the runner-up to #should, and
  # prefered by many people who prefer to be concise.
  #
  module Must
    # The #must method is functionaly the same as #should.
    #
    #   4.must == 3  #=> Expectation Error
    #
    def must(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                if !block.call
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "must not".
    #
    #   4.must! == 4  #=> Expectation Error
    #
    def must!(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :negate=>true, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                               if  block.call
    end

    # Alias for #must! method.
    alias_method :must_not, :must!
    alias_method :musnt   , :must!
    alias_method :wont    , :must!
  end

end

class ::Object #:nodoc:
  include AE::Must
end
