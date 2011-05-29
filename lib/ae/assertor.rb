require 'ae/assertion'
require 'ae/basic_object'
require 'ansi/diff'

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
    # reset - Hash which can be used to set counts manually (optional).
    #
    # Returns the Hash of previous counts.
    def self.recount(reset=nil)
      old_counts = counts.dup
      if reset
        reset.each do |type, value|
          counts[type.to_sym] = value
        end
      else
        counts.replace(ZERO_COUNTS.dup)
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
    # is used by Assertor as the end call of an assertion.
    def self.assert(pass, error=nil, negated=nil, backtrace=nil)
      pass = negated ^ !!pass
      increment_counts(pass)
      if !pass
        backtrace = backtrace || caller
        raise_assertion(error, negated, backtrace)
      end
      return pass
    end

    # The intent of the method is to raise an assertion failure
    # class that the test framework supports.
    def self.raise_assertion(error, negated, backtrace=nil)
      if not ::Exception === error
        error = assertion_error.new(error)
      end
      error.set_negative(negated)
      error.set_backtrace(backtrace || caller)
      error.set_assertion(true)
      fail error
    end

    # Returns the Exception class to be raised when an assertion fails.
    def self.assertion_error
      ::Assertion
    end

    # NOT HAPPENING
    ## Is ::Assay defined. This is used for integration of the Assay library.
    #def self.assay?
    #  @_assay ||= defined?(::Assay)
    #end

    #
    #def self.message(sym, neg, *args, &blk)
    #  if method = Message.lookup(sym) 
    #    method = "non_#{method}" if neg
    #    Message.send(method, *args, &blk)
    #  else
    #    nil
    #  end
    #end

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
    #--
    # The use of #to_proc and #matches? as sepcial cases is not
    # a robust solution.
    #++
    def assert(*args, &block)
      return self if args.empty? && !block

      target = block || args.shift
      error  = nil

      # Lambda
      if ::Proc === target || target.respond_to?(:to_proc)
        block  = target.to_proc
        match  = args.shift
        result = block.arity > 0 ? block.call(@delegate) : block.call
        if match
          pass  = (match == result)
          error = @message || "#{match.inspect} == #{result.inspect}"
        else
          pass  = result
          error = @message || block.inspect  # "#{result.inspect}"
        end

      # Matcher
      elsif target.respond_to?(:matches?) # Matchers
        pass  = target.matches?(@delegate)
        error = @message || matcher_message(target) #|| target.inspect
        if target.respond_to?(:exception)
          #error_class = target.failure_class
          error = target.exception #(:backtrace=>@backtrace, :negated=>@negated)
        end

      # Truthiness
      else
        pass  = target     # truthiness
        error = args.shift # optional message for TestUnit compatiability
      end

      __assert__(pass, error)
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

      # Lambda
      if ::Proc === target #|| target.respond_to?(:to_proc)
        #block = target.to_proc
        match = args.shift || @delegate
        if exception?(match)
          $DEBUG, debug = false, $DEBUG  # b/c it always spits-out a NameError
          begin
            block.arity > 0 ? block.call(@delegate) : block.call
            pass  = false
            error = "#{match} not raised"
          rescue match => error
            pass  = true
            error = "#{match} raised"
          rescue ::Exception => error
            pass  = false
            error = "#{match} expected but #{error.class} was raised"
          ensure
            $DEBUG = debug
          end
        else
          result = block.arity > 0 ? block.call(@delegte) : block.call
          pass   = (match === result)
          error  = @message || "#{match.inspect} === #{result.inspect}"
        end

      # Matcher
      elsif target.respond_to?(:matches?)
        pass  = target.matches?(@delegate)
        error = @message || matcher_message(target) #|| target.inspect
        if target.respond_to?(:exception)
          #error_class = target.failure_class
          error = target.exception #failure(:backtrace=>@backtrace, :negated=>@negated)
        end

      # Case Equals
      else
        pass  = (target === @delegate)
        error = @message || "#{target.inspect} === #{@delegate.inspect}"
      end

      __assert__(pass, error)
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
    def method_missing(sym, *args, &block)
      error = @message || compare_message(sym, *args, &block) || generic_message(sym, *args, &block)

      pass = @delegate.__send__(sym, *args, &block)

      __assert__(pass, error)
    end


    # Simple assert.
    #--
    # TODO: Can the handling of the message be simplified/improved?
    #++
    def __assert__(pass, error=nil)
      Assertor.assert(pass, error, @negated, @backtrace)
    end

    #
    def matcher_message(matcher)
      if @negated
        if matcher.respond_to?(:negative_failure_message)
          return matcher.failure_message
        end
      else
        if matcher.respond_to?(:failure_message)
          return matcher.failure_message
        end
      end
      return nil
    end

    COMPARISON_OPERATORS = { :"==" => :"!=" }

    # Message to use when making a comparion assertion.
    def compare_message(operator, *args, &blk)
      return nil unless COMPARISON_OPERATORS.key?(operator)
      prefix = ""
      a, b   = @delegate.inspect, args.first.inspect
      if @negated
        op = COMPARISON_OPERATORS[operator]
        if op
          operator = op
        else
          prefix   = "NOT "
        end
      end
      if a.size > 13 or b.size > 13
        diff = ::ANSI::Diff.new(a,b)
        prefix + "a #{operator} b\na) " + diff.diff1 + "\nb) " + diff.diff2
      else
        prefix + "#{a.inspect} #{operator} #{b.inspect}"
      end
    end

    # Puts together a suitable error message.
    #
    def generic_message(op, *a, &b)
      inspection = @delegate.send(:inspect)
      if @negated
        "! #{inspection} #{op} #{a.collect{|x| x.inspect}.join(',')}"
      else
        "#{inspection} #{op} #{a.collect{|x| x.inspect}.join(',')}"
      end
      #self.class.message(m)[@delegate, *a] )
    end

  end

end

# DO WE MAKE THESE EXCEPTIONS?
#class BasicObject
#  def assert
#  end
#end

# Copyright (c) 2008,2009 Thomas Sawyer
