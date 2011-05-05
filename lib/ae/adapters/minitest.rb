require 'ae'

AE.assertion_error = ::MiniTest::Assertion

module MiniTest #:nodoc:
  class Unit #:nodoc:
    # MiniTest tracks assertion counts internally in it's Unit class via the 
    # +assertion_count+ attribute. To work with AE we need add in AE's assertion
    # total by overriding the +assertion_count+ method.
    def assertion_count
      @assertion_count + AE::Assertor.counts[:total]
    end
    # To teach MiniTest to recognize AE's expanded concept of assertions
    # we add in an extra capture clause to the it's #puke method.
    def puke c, m, x
      case x
      when MiniTest::Skip
        @skips = @skips + 1
        x = "Skipped:\n#{m}(#{c}) [#{location x}]:\n#{x.message}\n"
      when MiniTest::Assertion
        @failures = @failures + 1
        x = "Failure:\n#{m}(#{c}) [#{location x}]:\n#{x.message}\n"
      when x.respond_to?(:assertion?) && x.assertion?
        @failures = @failures + 1
        x = "Failure:\n#{m}(#{c}) [#{location x}]:\n#{x.message}\n"
      else
        @errors = @errors + 1
        b = MiniTest::filter_backtrace(x.backtrace).join("\n ")
        x = "Error:\n#{m}(#{c}):\n#{x.class}: #{x.message}\n #{b}\n"
      end
      @report << x
      x[0, 1]
    end
  end
end

