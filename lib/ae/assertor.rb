require 'ae/assertion'
require 'ae/basic_object'

# = Assertor (Assertion Functor)
#
# == What is a Functor?
#
# A Functor is a succinct name for what is also know as a
# Higher Order Function. In other words, it is a function
# that acts on a function. It is very similiar to a delegator
# in most respects, but is conditioned on the operation applied,
# rather then simply passing-off to an alternate reciever.
#
class Assertor < AE::BasicObject

  #
  #instance_methods.each{ |m| protected m unless /^(__|object_id$)/ =~ m.to_s }

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
  # TODO: Should this return a new Assertor instead of inplace negation?
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
  def assert(*args, &block)
    return self if args.empty? && !block

    target = block || args.shift

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
      msg    = @message || matcher_message(target) || target.inspect
    else
      pass   = target     # truthiness
      msg    = args.shift # optional mesage for TestUnit compatiability
    end

    __assert__(pass, msg)
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
      msg  = @message || matcher_message(target) || target.inspect
    else
      pass = (target === @delegate)
      msg  = @message || "#{target.inspect} === #{@delegate.inspect}"
    end

    __assert__(pass, msg)
  end

  # Is the +object+ an Exception or an instance of one.
  #--
  # TODO: Should we use a more libreral determination of exception.
  # e.g. <code>respond_to?(:exception)</code>.
  #++
  def exception?(object)
    ::Exception === object or ::Class === object and object.ancestors.include?(::Exception)
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

  private

  # Converts a missing methods into an Assertion.
  #
  def method_missing(sym, *a, &b)
    pass = @delegate.__send__(sym, *a, &b)
    #pass = @delegate.public_send(sym, *a, &b)
    __assert__(pass, @message || __msg__(sym, *a, &b))
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

  # Pure old simple assert.
  #--
  # TODO: Can the handling of the message be simplified/improved?
  #++
  def __assert__(pass, message=nil)
    pass = @negated ^ pass
    # msg = message || @message
    super(pass, message, @backtrace)
    #::Assertion.test(pass, :message=>message, :backtrace=>@backtrace)
    #return pass
  end

  # This method can be replaced to support alternate frameworks.
  # The idea is to use to record that an assertion took place. 
  # def framework_assert(pass, message)
  #   # by default nothing needed
  # end

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

  # TODO: Ultimately better messages might be nice.
  #
  #def self.message(op,&block)
  #  @message ||= {}
  #  block ? @message[op.to_sym] = block : @message[op.to_sym]
  #end
  #
  #message(:==){ |*a| "Expected #{a[0].inspect} to be equal to #{a[1].inspect}" }
end

# DO WE MAKE THESE EXCEPTIONS?
#class BasicObject
#  def assert
#  end
#end

# Copyright (c) 2008,2009 Thomas Sawyer
