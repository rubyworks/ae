require 'ae'

AE.assertion_error = ::Minitest::Assertion

module Minitest #:nodoc:
  class Test #:nodoc:
    # Override capture_exceptions to recognize AE assertion errors
    # as test failures rather than errors.
    alias_method :capture_exceptions_without_ae, :capture_exceptions

    def capture_exceptions
      yield
    rescue *PASSTHROUGH_EXCEPTIONS
      raise
    rescue Assertion => e
      self.failures << e
    rescue Exception => e
      if e.respond_to?(:assertion?) && e.assertion?
        failure = Assertion.new(e.message)
        failure.set_backtrace(e.backtrace)
        self.failures << failure
      else
        self.failures << UnexpectedError.new(sanitize_exception(e))
      end
    end
  end
end

class AE::Assertor #:nodoc:
  # MiniTest tracks assertion counts internally. To work with AE we
  # override increment_counts to also update AE's own counter.
  def self.increment_counts(pass)
    counts[:total] += 1
    if pass
      counts[:pass] += 1
    else
      counts[:fail] += 1
    end
    return counts
  end
end
