require 'ae'

AE.assertion_error = ::Minitest::Assertion

module AE
  # Minitest adapter. AE raises Minitest::Assertion, so failures are
  # reported as failures, and each AE assertion is added to the
  # running test's assertion count.
  module MinitestAdapter
    # Notes the running test, and reports any other exception that
    # says it is an assertion as a failure rather than an error.
    module Test
      def capture_exceptions
        previous = ::Thread.current[:ae_minitest_test]
        ::Thread.current[:ae_minitest_test] = self
        super do
          begin
            yield
          rescue ::Minitest::Assertion
            raise
          rescue ::Exception => e
            raise unless e.respond_to?(:assertion?) && e.assertion?
            failure = ::Minitest::Assertion.new(e.message)
            failure.set_backtrace(e.backtrace)
            raise failure
          end
        end
      ensure
        ::Thread.current[:ae_minitest_test] = previous
      end
    end

    # Adds each AE assertion to the running test's count.
    module Counts
      def increment_counts(pass)
        test = ::Thread.current[:ae_minitest_test]
        test.assertions += 1 if test
        super
      end
    end
  end
end

Minitest::Test.prepend(AE::MinitestAdapter::Test)
AE::Assertor.singleton_class.prepend(AE::MinitestAdapter::Counts)
