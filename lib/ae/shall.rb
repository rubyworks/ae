require 'ae/assertion'

module AE

  # = Shall
  #
  #   "If a man will begin with certainties, he shall end in doubts; but if
  #    he will be content to begin with doubts he shall end in certainties."
  #                                       --Sir Francis Bacon (1561 - 1626)
  #
  module Shall
    # The #shall method can act as a functor, like #assert or #expect,
    # or as a described verification block.
    #
    #   4.shall == 3  #=> Expectation Error
    #
    #   4.shall "be three" do
    #     3
    #   end  #=> Expectation Error
    #
    def shall(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                if !block.call
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "shall not".
    #
    #   4.shall! == 4  #=> Expectation Error
    #
    #   4.shall! "be three" do
    #     4
    #   end  #=> Expectation Error
    #
    def shall!(msg=nil, &block)
      return Assertor.new(self, :message=>msg, :negate=>true, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                               if  block.call
    end

    # Alias for #shall! method.
    #
    alias_method :shall_not, :shall!
    alias_method :shant    , :shall!
  end

end

class ::Object #:nodoc:
  include AE::Shall
end
