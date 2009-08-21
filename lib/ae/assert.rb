require 'ae/assertion'

module AE

  # = Assert
  #
  #   "The reserve of modern assertions is sometimes pushed to extremes,
  #    in which the fear of being contradicted leads the writer to strip
  #    himself of almost all sense and meaning."
  #                              -- Sir Winston Churchill (1874 - 1965)
  #
  module Assert

    # Assert a operational relationship.
    #
    #   4.assert == 3
    #
    # If only a single test argument is given then
    # #assert simple validates that it evalutate to true.
    # An optional message argument can be given in this
    # case which will be used instead of the deafult message.
    #
    #   assert(4==3, "not the same thing")
    #
    # In block form, #assert ensures the block evalutes
    # truthfully, i.e. not as nil or false.
    #
    #   assert{ 4==3 }
    #
    # If an argument is given with a block, #assert compares
    # the argument to the result of evaluating the block.
    #
    #   assert(4){ 3 }
    #
    # #assert compares the expected value and the actual
    # value with regular equality <code>#==</code>.
    #
    def assert(test=NoArgument, msg=nil, &block)
      return Assertion::Assertor.new(self, :backtrace=>caller) if NoArgument==test && !block
      if block
        result = block.call
        if NoArgument == test
          raise Assertion.new(msg, :backtrace=>caller) unless result
        else
          pass = (test == result)
          msg  = "#{test} != #{result}" unless msg
          raise Assertion.new(msg, :backtrace=>caller) unless pass
        end
      else
        msg = "failed assertion (no message given)" unless msg
        raise Assertion.new(msg, :backtrace=>caller) unless test
      end
    end

    # Assert not an operational relationship.
    # Read it as "assert not".
    #
    #   4.assert! == 4
    #
    # See #assert.
    #
    # AUHTOR'S NOTE: This method would not be necessary
    # if Ruby would allow +!=+ to be define as a method,
    # or at least +!+ as a unary method.
    #
    def assert!(test=Exception, msg=nil, &block)
      return Assertion::Assertor.new(self, :backtrace=>caller, :negate=>true) if NoArgument==test && !block
      if block
        result = block.call
        if NoArgument == test
          raise Assertion.new(msg, :backtrace=>caller, :negate=>true) if result
        else
          pass = (test == result)
          msg  = "#{test} != #{result}" unless msg
          raise Assertion.new(msg, :backtrace=>caller, :negate=>true) if pass
        end
      else
        msg = "failed assertion (no message given)" unless msg
        raise Assertion.new(msg, :backtrace=>caller, :negate=>true) if test
      end
    end


    # Alias for #assert!.
    #
    # 4.assert_not == 4  #=> Assertion Error
    #
    alias_method :assert_not, :assert!

    # Alias for #assert!.
    #
    # 4.refute == 4  #=> Assertion Error
    #
    alias_method :refute, :assert!

  end

end

class ::Object #:nodoc:
  include AE::Assert
end
