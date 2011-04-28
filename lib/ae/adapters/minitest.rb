require 'ae'

AE.assertion_error = ::MiniTest::Assertion

# MiniTest tracks assertion counts internally in it's Unit class via the 
# +assertion_count+ attribute. To work with AE we need add in AE's assertion
# total by overriding the +assertion_count+ method.

module MiniTest #:nodoc:
  class Unit #:nodoc:
    def assertion_count
      @assertion_count + AE::Assertor.counts[:total]
    end
  end
end


