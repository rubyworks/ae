require 'ae/assertion'
require 'ae/basic_object'

module AE

  # Assertor is the underlying class of the whole system. It implements
  # the flutent assertion notation.
  #
  # An Assertor is an Assertion Functor. A Functor is a succinct name for what
  # is also known as Higher Order Function. In other words, it is a function
  # that acts on a function. It is very similiar  to a delegator in most
  # respects, but is conditioned on the operation applied, rather then simply
  # passing-off to an alternate reciever.
  #
  class Assertor < AE::BasicObject

    # Initial settings of assertion counts.
    ZERO_COUNTS = {:total=>0,:pass=>0,:fail=>0}

    # Initialize assertion counts global variable.
    $assertion_counts = ZERO_COUNTS.dup

    # Returns Hash used to track assertion counts.
    def self.counts
      $assertion_counts
    end

    # Reset assertion counts.
    #
    # reset - Hash which will be used to set counts manually (optional).
    #
    # Returns the Hash of previous counts.
    def self.recount(reset={})
      old_counts = counts.dup
      if reset.empty?
        counts.replace(ZERO_COUNTS.dup)
      else
        reset.each do |type, value|
          counts[type.to_sym] = value
        end
      end
      return old_counts
    end

    # Increment assertion counts. If +pass+ is +true+ then +:total+
    # and +:pass+ are increased. If +pass+ if +false+ then +:total+ 
    # and +:fail+ are incremented.
    def self.increment_counts(pass)
      counts[:total] += 1
      if pass
        counts[:pass] += 1
      else
        counts[:fail] += 1
      end
      return counts
    end

    # Basic assertion. This method by-passes all the Assertor fluent
    # constructs and performs the underlying assertion procedure. It
    # is used by Assertor as the end result of an assertion.
    def self.assert(pass, message=nil, backtrace=nil, error=nil)
      increment_counts(pass)
      if !pass
        backtrace = backtrace || caller
        #message   = message   || 'flunk'
        raise_assertion(message, backtrace, error)
      end
      return pass
    end

    # The intent of the method is to raise the assertion failure
    # class that a test framework uses.
    def self.raise_assertion(message, backtrace=nil, error=nil)
      error = assertion_error.new(message) if !error
      error.set_backtrace(backtrace || caller)
      error.set_assertion(true)
      fail error
    end

    # Returns the Exception class to be raised when an assertion fails.
    def self.assertion_error
      ::Assertion
    end

    # Is ::Assay defined. This is used for integration of the Assay library.
    def self.assay?
      @_assay ||= defined?(::Assay)
    end

    #
    if ::RUBY_VERSION >= '1.9'
      eval "private :==, :!, :!="  # using eval here b/c it's a syntax error in 1.8-
    end

    # New Assertor.
    #
    def initialize(delegate, opts={}) #, backtrace)
      @delegate  = delegate
      @message   = opts[:message]
      @backtrace = opts[:backtrace] || caller #[1..-1]
      @negated   = !!opts[:negated]
    end

    # Negate the meaning of the assertion.
    #
    #--
    # TODO: Should this return a new Assertor instead of in place negation?
    #++
    def not(msg=nil)
      @negated = !@negated
      @message = msg if msg
      self
    end

    # Internal assert, provides all functionality associated
    # with external #assert method. (See Assert#assert)
    #
    # NOTE: I'm calling YAGNI on using extra arguments to pass
    # to the block. The interface is much nicer if a macro is
    # created to handle any neccessry arguments. Eg.
    #
    #   assert something(parameter)
    #
    # instead of
    #
    #   assert something, parameter
    #
    # Returns +true+ or +false+ based on assertions success.
    def assert(*args, &block)
      return self if args.empty? && !block

      target = block || args.shift
      error  = nil

      if ::Proc === target || target.respond_to?(:to_proc)
        block  = target.to_proc
        match  = args.shift
        result = block.arity > 0 ? block.call(@delegate) : block.call
        if match
          pass = (match == result)
          msg  = @message || "#{match.inspect} == #{result.inspect}"
        else
          pass = result
          msg  = @message || block.inspect  # "#{result.inspect}"
        end
      elsif target.respond_to?(:matches?)
        pass   = target.matches?(@delegate)
        msg    = @message #|| matcher_message(target) || target.inspect
        if target.respond_to?(:failure)
          #error_class = target.failure_class
          error = target.failure
        end
      else
        pass   = target     # truthiness
        msg    = args.shift # optional message for TestUnit compatiability
      end

      __assert__(pass, msg, error)
    end

    # Internal expect, provides all functionality associated
    # with external #expect method. (See Expect#expect)
    #
    #--
    # TODO: Should we deprecate the receiver matches in favor of #expected ?
    # In other words, should the <code>|| @delegate</code> be dropped?
    #++
    def expect(*args, &block)
      return self if args.empty? && !block  # same as #assert

      target = block || args.shift
      error  = nil

      if ::Proc === target #|| target.respond_to?(:to_proc)
        #block = target.to_proc
        match = args.shift || @delegate
        if exception?(match)
          $DEBUG, debug = false, $DEBUG  # b/c it always spits-out a NameError
          begin
            block.arity > 0 ? block.call(@delegate) : block.call
            pass = false
            msg  = "#{match} not raised"
          rescue match => error
            pass = true
            msg  = "#{match} raised"
          rescue ::Exception => error
            pass = false
            msg  = "#{match} expected but #{error.class} was raised"
          ensure
            $DEBUG = debug
          end
        else
          result = block.arity > 0 ? block.call(@delegte) : block.call
          pass   = (match === result)
          msg    = @message || "#{match.inspect} === #{result.inspect}"
        end
      elsif target.respond_to?(:matches?)
        pass = target.matches?(@delegate)
        msg  = @message #|| matcher_message(target) || target.inspect
        if target.respond_to?(:failure)
          #error_class = target.failure_class
          error = target.failure
        end
      else
        pass = (target === @delegate)
        msg  = @message || "#{target.inspect} === #{@delegate.inspect}"
      end

      __assert__(pass, msg, error)
    end

    #
    def flunk(message=nil, backtrace=nil)
      __assert__(false, message || @message)
    end

    # Ruby seems to have a quark in it's implementation whereby
    # this must be defined explicitly, otherwise it somehow
    # skips #method_missing.
    def =~(match)
      method_missing(:"=~", match)
    end

    #
    def send(op, *a, &b)
      method_missing(op, *a, &b)
    end

    #
    def inspect
      @delegate.inspect
    end

    private

    # Is the +object+ an Exception or an instance of one?
    #--
    # TODO: Should we use a more libreral determination of exception.
    # e.g. <code>respond_to?(:exception)</code>.
    #++
    def exception?(object)
      ::Exception === object or ::Class === object and object.ancestors.include?(::Exception)
    end

    # Converts a missing method into an Assertion.
    #
    # TODO: In future should probably be `@delegate.public_send(sym, *a, &b)`.
    def method_missing(sym, *a, &b)
      error = nil
      if Assertor.assay? && error = ::Assay.lookup(sym)
        message = nil
        error   = error.new(@message, :arguments=>[@delegate, *a], :negated=>@negated, :backtrace=>@backtrace)
        #if error
        #  if @negated
        #    message = @message || error.fail_message!(@delegate, *a)
        #  else
        #    message = @message || error.fail_message(@delegate, *a)
        #  end
        #end
      else
        message = @message || __msg__(sym, *a, &b)
        error   = nil
      end
      pass = @delegate.__send__(sym, *a, &b)
      __assert__(pass, message, error)
    end

    # Puts together a suitable error message.
    #
    def __msg__(m, *a, &b)
      inspection = @delegate.send(:inspect)
      if @negated
        "! #{inspection} #{m} #{a.collect{|x| x.inspect}.join(',')}"
      else
        "#{inspection} #{m} #{a.collect{|x| x.inspect}.join(',')}"
      end
      #self.class.message(m)[@delegate, *a] )
    end

    # Simple assert.
    #--
    # TODO: Can the handling of the message be simplified/improved?
    #++
    def __assert__(pass, message=nil, error=nil)
      pass = @negated ^ pass
      Assertor.assert(pass, message, @backtrace, error)
    end

=begin
    #
    def matcher_message(matcher)
      if @negated
        if matcher.respond_to?(:negative_failure_message)
          return matcher.failure_message
        end
      end
      if matcher.respond_to?(:failure_message)
        return matcher.failure_message
      end
      false
    end
=end

    # TODO: Ultimately better messages might be nice.
    #
    #def self.message(op,&block)
    #  @message ||= {}
    #  block ? @message[op.to_sym] = block : @message[op.to_sym]
    #end
    #
    #message(:==){ |*a| "Expected #{a[0].inspect} to be equal to #{a[1].inspect}" }
  end

end

# DO WE MAKE THESE EXCEPTIONS?
#class BasicObject
#  def assert
#  end
#end

# Copyright (c) 2008,2009 Thomas Sawyer
