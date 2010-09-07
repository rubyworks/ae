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

require 'ae'

class Assertion #:nodoc:

  def self.increment(pass)
    @count += 1
    @fails += 1 unless pass

    $_result.add_assertion if $_result
  end

  def self.framework_flunk(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = Test::Unit::AssertionFailedError.new(message)
    err.set_backtrace(backtrace) if backtrace
    fail err
  end

end
