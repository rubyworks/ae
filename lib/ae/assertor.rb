require 'ae/assertion'

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
class Assertor

  $assertions = 0
  $failures   = 0

  #
  instance_methods.each{ |m| protected m unless /^__/ =~ m.to_s }

  # New Assertor.
  #
  def initialize(delegate, opts={}) #, backtrace)
    @delegate  = delegate
    @message   = opts[:message]
    @backtrace = opts[:backtrace] || caller #[1..-1]
    @negated   = !!opts[:negated]
  end

  #
  def not(msg=nil, &block)
    @negated = !@negated
    block ? assert(msg, &block) : self
  end

  # Internal assert, provides all functionality associated
  # with external #assert Object method.
  #
  # TODO: I'm calling YAGNI on any extra arguments to the block.
  def assert(*args, &block)
    return self if args.empty? && !block_given?
    block = args.shift if !block_given? && Proc === args.first
    if block
      pass = block.arity > 0 ? block.call(@delegate) : block.call  #@delegate.instance_eval(&block)
      msg = args.shift || @message || block.inspect
    else
      pass = args.shift  # truthiness
      msg  = args.shift
    end
    __assert__(pass, msg)
  end

  #
  #def expect(*args, &block)
  #  return self if args.empty? && !block_given?
  #  block = args.shift if !block_given? && Proc === args.first
  #  if block
  #    pass = block.arity > 0 ? block.call(@delegate) : block.call  #@delegate.instance_eval(&block)
  #    msg = args.shift || @message || block.inspect
  #  else
  #    pass = args.shift  # truthiness
  #    msg  = args.shift
  #  end
  #  __assert__(pass, msg)
  #end

  #
  def flunk(msg=nil)
    $failures += 1
    fail Assertion.new(msg || @message, :backtrace=>@backtrace)
  end

  # Ruby seems to have a quark in it's implementation whereby
  # this must be defined explicitly, otherwise it somehow
  # skips #method_missing.
  def =~(match)
    method_missing(:"=~", match)
  end

  private

  # Converts a missing methods into an Assertion.
  #
  def method_missing(sym, *a, &b)
    pass = @delegate.__send__(sym, *a, &b)
    __assert__(pass, @message || __msg__(sym, *a, &b))
    #Assertor.count += 1
    #if (@negated ? pass : !pass)
    #unless @negated ^ pass
    #  msg = @message || __msg__(sym, *a, &b)
    #  flunk(msg) #fail Assertion.new(msg, :backtrace=>@backtrace)
    #end
  end

  # Puts together a suitable error message.
  #
  def __msg__(m, *a, &b)
    if @negated
      "! #{@delegate.inspect} #{m} #{a.collect{|x| x.inspect}.join(',')}"
    else
      "#{@delegate.inspect} #{m} #{a.collect{|x| x.inspect}.join(',')}"
    end
    #self.class.message(m)[@delegate, *a] )
  end

  # Pure old simple assert.
  def __assert__(pass, msg=nil)
    $assertions += 1
    unless @negated ^ pass
      flunk(msg || @message) #raise Assertion.new(msg, :backtrace=>@backtrace)
    end
    @negated ? !pass : !!pass
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

# Copyright (c) 2008,2009 Thomas Sawyer
