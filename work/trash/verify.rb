require 'ae/assertion'

module AE

  # = Verify
  #
  #   "You will find it a very good practice always to verify
  #    your references sir."
  #                                  --Martin Routh
  #
  module Verify

    # Same as #expect but only as a functor.
    #
    #   4.verify == 3  #=> Expectation Error
    #
    def verify(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                if !block.call
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "must not".
    #
    #   4.verify! == 4  #=> Expectation Error
    #
    def verify!(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :negate=>true, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                               if  block.call
    end

    # See #verify! method.
    #
    alias_method :refute , :verify!

  end

end

class ::Object #:nodoc:
  include AE::Verify
end

