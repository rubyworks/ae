class MiniTest::Unit #:nodoc:
  def status io = @@out
    ae_count = ::Assertion.count
    format = "%d tests, %d assertions, %d failures, %d errors, %d skips"
    io.puts format % [test_count, assertion_count + ae_count, failures, errors, skips]
  end
end

require 'ae'

class Assertion #:nodoc:

  def self.framework_flunk(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = MiniTest::Assertion.new(message)
    err.set_backtrace(backtrace) if backtrace
    fail err
  end

end
