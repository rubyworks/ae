$assertion_counts = {:total=>0,:pass=>0,:fail=>0}

module Kernel
  # Make an assertion.
  def assert(test, message=nil, backtrace=nil)
    $assertion_counts[:total] += 1
    if test
      $assertion_counts[:pass] += 1
      test
    else
      $assertion_counts[:fail] += 1
      backtrace = backtrace || caller
      message   = message   || 'flunk'
      raise_assertion(:message=>message,:backtrace=>backtrace)
    end
  end

  # Use this as needed to circument potential overrides.
  alias_method :__assert__, :assert

  # This method can be replaced to support alternate frameworks.
  # The intent of the method is to raise the assertion failure
  # class the frame work uses.
  def raise_assertion(options)
    message   = options[:message]
    backtrace = options[:backtrace] || caller
    raise Assertion.new(message, :backtrace=>backtrace)
  end

  # Directly raise an Assertion failure.
  def flunk(message=nil, backtrace=nil)
    __assert__(false, message, backtrace)
  end

end
