require 'ae/assertion'

module AE

  # = Should
  #
  #  "Always and never are two words you should always
  #   remember never to use."
  #                              --Wendell Johnson
  #
  # The term *should* has become the defacto standard for
  # BDD assertions, so we support this nomenclature.
  #
  module Should
    # The #should method can act as a functor, like #assert or #expect,
    # or as a described verification block.
    #
    #   4.should == 3  #=> Expectation Error
    #
    #   4.should "be three" do
    #     3
    #   end  #=> Expectation Error
    #
    def should(msg=nil, &block)
      return Assertion::Assertor.new(self, :message=>msg, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                           if !block.call
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "should not".
    #
    #   4.should! == 4  #=> Expectation Error
    #
    #   4.should! "be three" do
    #     4
    #   end  #=> Expectation Error
    #
    def should!(msg=nil, &block)
      return Assertion::Assertor.new(self, :message=>msg, :negate=>true, :backtrace=>caller) if !block
      raise  Assertion.new(msg, :backtrace=>caller)                                          if  block.call
    end

    # Alias for #should! method.
    #
    alias_method :should_not, :should!
    alias_method :shouldnt  , :should!
    alias_method :shant     , :should!
  end

end

class ::Object #:nodoc:
  include AE::Should
end
