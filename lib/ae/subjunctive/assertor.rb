require 'ae/assertor'

module AE

  # The subjunctive form of Assertor.
  #
  #
  #
  # Suited for assertion terms like #should and #must.
  #
  # TODO: Maybe this form of #not and #is (instead of #be) for Assertor itself?
  #
  class Assertor::Subjunctive < Assertor

    #
    def not(*args, &block)
      @negated = !@negated
      return self if args.empty? && !block_given?
      be(*args, &block)
    end

    # Like #assert, except if an argument if provided and no block,
    # uses #=== to compare the argument to the receiver. This allows
    # for statements of the form:
    #
    #   5.should.be Numeric
    #
    def be(*args, &block)
      return self if args.empty? && !block
      block = args.shift if !block_given? && Proc == args.first
      if block
        pass = block.arity > 0 ? block.call(@delegate) : block.call  #@delegate.instance_eval(&block)
        msg = args.shift || @message || block.inspect
      else
        pass = (args.shift == self) # equality
        msg  = args.shift
      end
      __assert__(pass, msg)
    end

    # Like #assert, except if an argument if provided and no block,
    # uses #=== to compare the argument to the receiver. This allows
    # for statements of the form:
    #
    #   5.assert.is Numeric
    #
    def is(*args, &block)
      return self if args.empty? && !block
      block = args.shift if !block_given? && Proc == args.first
      if block
        pass = block.arity > 0 ? block.call(@delegate) : block.call  #@delegate.instance_eval(&block)
        msg = args.shift || @message || block.inspect
      else
        pass = (args.shift == self) # equality
        msg  = args.shift
      end
      __assert__(pass, msg)
    end

    alias_method :does, :is

    # Indefinite article.
    #
    def a(*args, &block)
      return self if args.empty? && !block
      block = args.shift if !block_given? && Proc == args.first
      if block
        pass = block.arity > 0 ? block.call(@delegate) : block.call  #@delegate.instance_eval(&block)
        msg = args.shift || @message || block.inspect
      else
        pass = (args.shift === self) # case equality
        msg  = args.shift
      end
      __assert__(pass, msg)
    end

    alias_method :an, :a


    # Same as #identical? but flows better in the subjunctive.
    def identical_to?(object) self.equal?(object) end

    # See identical_to?
    alias_method :same_as?, :identical_to?
  end

end#module AE

# Copyright (c) 2008,2009 Thomas Sawyer [Ruby License]
