require 'ae'

AE.assertion_error = ::Test::Unit::AssertionFailedError

module Test #:nodoc:
  module Unit #:nodoc:

    module AEAssertionHandler
      class << self
        def included(base)
          base.exception_handler(:handle_ae_assertion_error)
        end
      end

      private
      def handle_ae_assertion_error(exception)
        return false unless exception.respond_to?(:assertion?) && exception.assertion?
        problem_occurred
        add_failure(exception.message, exception.backtrace)
        true
      end
    end

    class TestCase #:nodoc:
      include AEAssertionHandler
    end
  end
end

class AE::Assertor #:nodoc:
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
