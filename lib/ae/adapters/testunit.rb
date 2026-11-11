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

module AE
  # Test::Unit adapter. Each AE assertion is added to the running
  # test's assertion count.
  module TestUnitAdapter
    # Notes the running test.
    module Test
      def run(*args, **kw, &block)
        previous = ::Thread.current[:ae_testunit_test]
        ::Thread.current[:ae_testunit_test] = self
        super
      ensure
        ::Thread.current[:ae_testunit_test] = previous
      end
    end

    # Adds each AE assertion to the running test's count.
    module Counts
      def increment_counts(pass)
        test = ::Thread.current[:ae_testunit_test]
        test.__send__(:add_assertion) if test
        super
      end
    end
  end
end

Test::Unit::TestCase.prepend(AE::TestUnitAdapter::Test)
AE::Assertor.singleton_class.prepend(AE::TestUnitAdapter::Counts)
