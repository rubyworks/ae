require 'ae'

AE.assertion_error = ::Test::Unit::AssertionFailedError

# TestUnit uses #add_assertion on it's +result+ object to track counts.
# We capture the result object by overriding the TestCase#run method,
# store it in a global variable and then use it when AE increments
# assertion counts.

module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      alias_method :_run, :run
      def run(result, &block)
        $_test_unit_result = result
        _run(result, &block)
      end
    end
  end
end

class AE::Assertor #:nodoc:
  def self.increment_counts(pass)
    $_test_unit_result.add_assertion if $_test_unit_result
    counts[:total] += 1
    if pass
      counts[:pass] += 1
    else
      counts[:fail] += 1
    end
    return counts
  end
end

