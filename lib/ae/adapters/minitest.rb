require 'ae'

AE.assertion_error = ::MiniTest::Assertion

module MiniTest #:nodoc:
  class Unit #:nodoc:

    # MiniTest tracks assertion counts internally in it's Unit class via the 
    # +assertion_count+ attribute. To work with AE we need add in AE's assertion
    # total by overriding the +assertion_count+ method.
    #
    # @return [Integer] Number of assertions made.
    def assertion_count
      @assertion_count + AE::Assertor.counts[:total]
    end

    # To teach MiniTest to recognize AE's expanded concept of assertions
    # we add in an extra capture clause to it's #puke method.
    #
    # @return [String] Status code is `S`, `F`, or `E`.
    def puke k, m, e
      case e
      when MiniTest::Skip
        @skips += 1
        return "S" unless @verbose
        e = "Skipped:\n#{m}(#{k}) [#{location e}]:\n#{e.message}\n"
      when MiniTest::Assertion
        @failures += 1
        e = "Failure:\n#{m}(#{k}) [#{location e}]:\n#{e.message}\n"
      else
        if e.respond_to?(:assertion?) && e.assertion?
          @failures += 1
          e = "Failure:\n#{m}(#{c}) [#{location e}]:\n#{e.message}\n"
        else
          @errors += 1
          b = MiniTest::filter_backtrace(e.backtrace).join "\n    "
          e = "Error:\n#{m}(#{k}):\n#{e.class}: #{e.message}\n    #{b}\n"
        end
      end
      @report << e
      e[0, 1]
    end

  end
end

