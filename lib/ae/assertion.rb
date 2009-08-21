require 'ae/core_ext'

# = Assertion
#
# This is the underlying Exception class of the whole system.
#
class Assertion < Exception

  #
  def initialize(message=nil, opts={})
    backtrace = opts[:backtrace]
    super(message)
    set_backtrace(backtrace) if backtrace
  end

  def to_s
    'fail ' + super
  end

  # = Assertor -- Assertion Functor
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
    hide = instance_methods.each{ |m| protected m unless /^__/ =~ m.to_s }

    private

    # New Assertor.
    #
    def initialize(delegate, opts={}) #, backtrace)
      @delegate  = delegate
      @negate    = opts[:negate]
      @message   = opts[:message]
      @backtrace = opts[:backtrace] || caller #[1..-1]
    end

    # Converts missing methods into an Assertion.
    #
    def method_missing(sym, *a, &b)
      pass = @delegate.__send__(sym, *a, &b)
      if (@negate ? pass : !pass)
        msg = @message || __msg__(sym, *a, &b)
        fail Assertion.new(msg, :backtrace=>@backtrace)
      end
    end

    # Puts together a suitable error message.
    #
    def __msg__(m, *a, &b)
      if @negate
        "! #{@delegate.inspect} #{m} #{a.collect{|x| x.inspect}.join(',')}"
      else
        "#{@delegate.inspect} #{m} #{a.collect{|x| x.inspect}.join(',')}"
      end
      #self.class.message(m)[@delegate, *a] )
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

end

# Copyright [Ruby License] (c) 2008,2009 Tiger Ops
