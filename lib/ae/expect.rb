require 'ae/assertion'

module AE

  # = Expect
  #
  #   "When love and skill work together, expect a masterpiece."
  #                                 --John Ruskin (1819 - 1900)
  #
  module Expect

    # The #expect method is a convenient tool for defining
    # certain sets of expectations in your specifications.
    #
    # Expect is used to expect a result from a block of code.
    # If the argument to expect is a subclass of Exception
    # or instance thereof, then the block is monitored for
    # the raising of such an exception.
    #
    #   expect StandardError do
    #     raise ArgumentError
    #   end 
    #
    # All other expectations are compared using case equality (#===). 
    # This allows one to verify matching Regexp.
    #
    #   expect /x/ do
    #     "x"
    #   end 
    #
    # As well as checking that an object is an instance of a given Class.
    #
    #   expect String do
    #     "x"
    #   end 
    #
    # Like #assert it can be used to designate an expectation
    # via a *functor*.
    #
    #   4.expect == 3
    #
    #--
    # TODO: Support matchers.
    #
    # TODO: respond_to?(:exception) && exp = exception if Exception === exp
    #++
    def expect(*args, &block)
      # same as assert if no arguments of block given
      return Assertor.new(self, :backtrace=>caller) if args.empty? && !block

      target = block || args.shift

      if Proc === target || target.respond_to?(:to_proc)
        block = target.to_proc
        exp   = args.empty? ? self : args.shift
        if Exception === exp || (Class===exp && exp.ancestors.include?(Exception))
          begin
            block.call
            pass = false
            msg  = "#{exp} not raised"
          rescue exp => error
            pass = true
          rescue Exception => error
            pass = false
            msg  = "#{exp} expected but #{error.class} was raised"
          end
        else
          res  = block.call
          pass = (exp === res)
          msg  = "#{exp} === #{res}"
        end
      elsif target.respond_to?(:matches?)
        pass = target.matches?(@delegate)
        msg  = matcher_message(target) || target.inspect
      else
        pass = (target === self)
        msg  = "#{target} === #{self}"
      end

      flunk(msg, caller) unless pass
    end

    # Designate a negated expectation. Read this as "expect not".
    #
    # See #expect.
    #
    def expect!(exp=NoArgument, &block)
      return Assertor.new(self, :backtrace=>caller) if args.empty? && !block

      target = block || args.shift

      if Proc === target || target.respond_to?(:to_proc)
        block = target.to_proc
        exp   = args.empty? ? self : args.shift
        if Exception === exp || (Class===exp && exp.is?(Exception))
          begin
            block.call
            pass = true
          rescue exp => error
            pass = false
            msg  = "#{exp} raised"
          rescue Exception => error
            pass = true
            #msg  = "#{exp} expected but #{error.class} was raised"
          end
        else
          res  = block.call
          pass = !(exp === res)
          msg  = "not #{exp} === #{res}"
        end
      else
        pass = !(target === self)
        msg  = "not #{target} === #{self}"
      end

      flunk(msg, caller) unless pass
    end

    # Alias for #expect! method.
    alias_method :forbid, :expect!

    # Like #expect but uses the reciever as the object
    # of expectation.
    #
    #   /x/.expected do
    #     "oooxooo"
    #   end
    #
    def expected(*args, &block)
      expect(self, *args, &block)
    end

  end

end#module QED

class ::Object #:nodoc:
  include AE::Expect
end

