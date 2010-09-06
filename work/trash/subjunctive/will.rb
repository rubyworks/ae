require 'ae/assertion'

module AE

  # = Will
  #
  #  "After an access cover has been secured by 16 hold-down screws,
  #   it will be discovered that the gasket has been omitted."
  #                                     -- De la Lastra's Corollary
  #
  module Will

    # The #will methid is the same as #should.
    #
    #   4.will == 3  #=> Expectation Error
    #
    def will(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                if !block.call
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "will not".
    #
    #   4.will! == 4  #=> Expectation Error
    #
    def will!(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :negate=>true, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                               if  block.call
    end

    # Alias for #will! method.
    alias_method :wont, :will!

  end

end

class ::Object #:nodoc:
  include AE::Will
end
