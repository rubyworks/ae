# TODO: This needs to be imporved. See KO project for
# better implementation.

module AE

  #
  module Okay

    #
    def check(msg=nil, &block)
      if block.arity == 0
        @__c__ = nil
        assert(block.call, msg)
      else
        @__c__ = [block, msg]
      end
    end

    #
    def ok(*args)
      block, msg = *@__c__
      assert(block.call(*args), msg)
    end

    #
    def no(*args)
      block, msg = *@__c__
      refute(block.call(*args), msg)
    end

  end

end

class ::Object #:nodoc:
  include AE::Okay
end

