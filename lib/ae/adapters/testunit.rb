require 'ae'

AE.assertion_error = ::Test::Unit::AssertionFailedError

# TestUnit uses #add_assertion on it's +result+ object to track counts.
# We capture the result object by overriding the TestCase#run method,
# store it in a global variable and then use it when AE increments
# assertion counts.
#
# In addition we teach #run to recognize any Exception class that
# responds to #assertion? in the affirmative as an assertion
# rather than an error.
#
module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      # These exceptions are not caught by #run.
      PASSTHROUGH_EXCEPTIONS = [NoMemoryError, SignalException, Interrupt, SystemExit] 
      # Runs the individual test method represented by this
      # instance of the fixture, collecting statistics, failures
      # and errors in result.
      def run(result)
        $_test_unit_result = result
        yield(STARTED, name)
        @_result = result
        begin
          setup
          __send__(@method_name)
        rescue AssertionFailedError => e
          add_failure(e.message, e.backtrace)
        rescue Exception => e
          if e.respond_to?(:assertion?) && e.assertion?
            add_failure(e.message, e.backtrace)
          else
            raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
            add_error($!)
          end
        ensure
          begin
            teardown
          rescue AssertionFailedError => e
            add_failure(e.message, e.backtrace)
          rescue Exception => e
            if e.respond_to?(:assertion?) && e.assertion?
              add_failure(e.message, e.backtrace)
            else
              raise if PASSTHROUGH_EXCEPTIONS.include? $!.class
              add_error($!)
            end
          end
        end
        result.add_run
        yield(FINISHED, name)
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

