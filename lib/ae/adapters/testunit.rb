require 'ae'

module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      alias_method :_run, :run
      def run(result, &block)
        $_result = result
        _run(result, &block)
      end
    end
  end
end

module Kernel #:nodoc:

  alias __assert_without_testunit__ __assert__

  # For some reason TestUnit needs this to count correctly.
  def __assert__(test, message=nil, backtrace=nil)
    backtrace ||= caller
    $_result.add_assertion if $_result
    __assert_without_testunit__(test, message=nil, backtrace)
  end

  def raise_assertion(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = Test::Unit::AssertionFailedError.new(message)
    err.set_backtrace(backtrace) if backtrace
    fail err
  end

end
