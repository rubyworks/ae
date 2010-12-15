require 'ae'

module MiniTest #:nodoc:
  class Unit #:nodoc:
    def status io = @@out
      ae_count = $assertion_counts[:total]
      format = "%d tests, %d assertions, %d failures, %d errors, %d skips"
      io.puts format % [test_count, assertion_count + ae_count, failures, errors, skips]
    end
  end
end

module Kernel #:nodoc:

  def raise_assertion(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = MiniTest::Assertion.new(message)
    err.set_backtrace(backtrace) if backtrace
    fail err
  end

end


