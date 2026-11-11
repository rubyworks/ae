require 'ae/assertor'

module AE

  module Legacy #:nodoc:

    # Test::Unit Legacy Assertions
    #
    # This module provides a compatibility layer for Test::Unit.
    # This is an optional module and is intended for providing
    # an easier transition from Test::Unit to AE assertions.
    #
    # Note that two methods are not provided, +#assert_nothing_raised+,
    # and +#assert_nothing_thrown+.
    #
    module Assertions

      # Private method upon which all of the legacy assertions are based
      # (except for #assert itself).
      #
      # @raise [Assertion] If test fails.
      #
      # @return nothing
      def __assert__(test, msg=nil)
        msg = "failed assertion (no message given)" unless msg
        Assertor.assert(test, msg, false, caller[1..-1])
        nil
      end

      private :__assert__

      # The assertion upon which all other assertions are based.
      #
      # @example
      #   assert [1, 2].include?(5)
      #
      # With a block and no test, it works like #assert_block.
      #
      # @return [Assertor] if neither `test` nor a block is given
      def assert(*args, &block)
        if args.empty?
          return assert_block(&block) if block
          return Assertor.new(self, :backtrace=>caller)  # TODO: Probably remove this!
        end
        test, msg = *args
        msg = "failed assertion (no message given)" unless msg
        Assertor.assert(test, msg, false, caller)
        nil
      end

      # Passes if the block yields true.
      #
      # @example
      #   assert_block "Couldn't do the thing" do
      #     do_the_thing
      #   end
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_block(msg=nil) # :yields:
        test = yield
        msg = "assertion failed" unless msg
        __assert__(test, msg)
      end

      # Passes if expected == +actual.
      #
      # Note that the ordering of arguments is important,
      # since a helpful error message is generated when this
      # one fails that tells you the values of expected and actual.
      #
      # @example
      #   assert_equal 'MY STRING', 'my string'.upcase
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_equal(exp, act, msg=nil)
        test = (exp == act)
        msg  = "Expected #{act.inspect} to be equal to #{exp.inspect}" unless msg
        __assert__(test, msg)
      end

      # Passes if expected_float and actual_float are equal within delta tolerance.
      #
      # @example
      #   assert_in_delta 0.05, (50000.0 / 10**6), 0.00001
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_in_delta(exp, act, delta, msg=nil)
        test = (exp.to_f - act.to_f).abs <= delta.to_f
        msg  = "Expected #{exp} to be within #{delta} of #{act}" unless msg
        __assert__(test, msg)
      end

      # Passes if object .instance_of? klass
      #
      # @example
      #   assert_instance_of String, 'foo'
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_instance_of(cls, obj, msg=nil)
        test = obj.instance_of?(cls)
        msg  = "Expected #{obj.inspect} to be an instance of #{cls}" unless msg
        __assert__(test, msg)
      end

      # Passes if object .kind_of? klass
      #
      # @example
      #   assert_kind_of Object, 'foo'
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_kind_of(cls, obj, msg=nil)
        test = obj.kind_of?(cls)
        msg  = "Expected #{obj.inspect} to be a kind of #{cls}" unless msg
        __assert__(test, msg)
      end

      # Passes if string =~ pattern.
      #
      # @example
      #   assert_match(/\d+/, 'five, 6, seven')
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_match(exp, act, msg=nil)
        test = (act =~ exp)
        msg  = "Expected #{act.inspect} to match #{exp.inspect}" unless msg
        __assert__(test, msg)
      end

      # Passes if object is nil.
      #
      # @example
      #   assert_nil [1, 2].uniq!
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_nil(obj, msg=nil)
        test = obj.nil?
        msg  = "Expected #{obj.inspect} to be nil" unless msg
        __assert__(test, msg)
      end

      # Passes if regexp !~ string
      #
      # @example
      #   assert_no_match(/two/, 'one 2 three')
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_no_match(exp, act, msg=nil)
        test = (act !~ exp)
        msg  = "Expected #{act.inspect} not to match #{exp.inspect}" unless msg
        __assert__(test, msg)
      end

      # Passes if expected != actual
      #
      # @example
      #  assert_not_equal 'some string', 5
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_not_equal(exp, act, msg=nil)
        test = (exp != act)
        msg  = "Expected #{act.inspect} to not be equal to #{exp.inspect}" unless msg
        __assert__(test, msg)
      end

      # Passes if ! object .nil?
      #
      # @example
      #   assert_not_nil '1 two 3'.sub!(/two/, '2')
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_not_nil(obj, msg=nil)
        test = ! obj.nil?
        msg  = "Expected #{obj.inspect} to not be nil" unless msg
        __assert__(test, msg)
      end

      # Passes if ! actual .equal? expected
      #
      # @example
      #   assert_not_same Object.new, Object.new
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_not_same(exp, act, msg=nil)
        test = ! exp.equal?(act)
        msg  = "Expected #{act.inspect} to not be the same as #{exp.inspect}" unless msg
        __assert__(test, msg)
      end

      # Compares the +object1+ with +object2+ using operator.
      #
      # Passes if object1.send(operator, object2) is true.
      #
      # @example
      #   assert_operator 5, :>=, 4
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_operator(o1, op, o2, msg=nil)
        test = o1.__send__(op, o2)
        msg = "Expected #{o1}.#{op}(#{o2}) to be true" unless msg
        __assert__(test, msg)
      end

      # Passes if the block raises one of the given exceptions,
      # or a subclass of one. With none given, StandardError.
      #
      # @example
      #   assert_raise RuntimeError, LoadError do
      #     raise 'Boom!!!'
      #   end
      #
      # @raise [Assertion] if test fails
      #
      # @return [Exception] the exception raised
      def assert_raises(*args)
        msg  = (Module === args.last ? nil : args.pop)
        exps = args.empty? ? [StandardError] : args
        begin
          yield
        rescue *exps => e
          Assertor.assert(true)
          return e
        rescue SignalException, SystemExit, NoMemoryError
          raise
        rescue Exception => e
          msg = "Expected #{exps.join(' or ')} to be raised, but got #{e.class}: #{e.message}" unless msg
          __assert__(false, msg)
        end
        msg = "Expected #{exps.join(' or ')} to be raised" unless msg
        __assert__(false, msg)
      end

      alias_method :assert_raise, :assert_raises

      # Provides a way to assert that a procedure
      # <i>does not</i> raise an exception.
      #
      # @example
      #   refute_raises(StandardError){ raise }
      #
      #def assert_raises!(exception, &block)
      #  begin
      #    block.call(*a)
      #  rescue exception
      #    raise Assertion
      #  end
      #end
      #alias_method :refute_raises, :assert_raises!

      # Passes if +object+ respond_to? +method+.
      #
      # @example
      #   assert_respond_to 'bugbear', :slice
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_respond_to(obj, meth, msg=nil)
        msg  = "Expected #{obj} (#{obj.class}) to respond to ##{meth}" unless msg
        #flip = (Symbol === obj) && ! (Symbol === meth) # HACK for specs
        #obj, meth = meth, obj if flip
        test = obj.respond_to?(meth)
        __assert__(test, msg)
      end

      # Passes if +actual+ .equal? +expected+ (i.e. they are the same instance).
      #
      # @example
      #   o = Object.new
      #   assert_same(o, o)
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_same(exp, act, msg=nil)
        msg  = "Expected #{act.inspect} to be the same as #{exp.inspect}" unless msg
        test = exp.equal?(act)
        __assert__(test, msg)
      end

      # Passes if the method send returns a true value.
      # The parameter +send_array+ is composed of:
      #
      # * A receiver
      # * A method
      # * Arguments to the method
      #
      # @example
      #   assert_send [[1, 2], :include?, 4]
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_send(send_array, msg=nil)
        r, m, *args = *send_array
        test = r.__send__(m, *args)
        msg  = "Expected #{r}.#{m}(*#{args.inspect}) to return true" unless msg
        __assert__(test, msg)
      end

      # Passes if the block throws expected_symbol
      #
      # @example
      #   assert_throws :done do
      #     throw :done
      #   end
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_throws(sym, msg=nil)
        default = "Expected #{sym.inspect} to have been thrown"
        test = true
        catch(sym) do
          begin
            yield
          rescue UncaughtThrowError => e
            default += ", not #{e.tag.inspect}"
          end
          test = false
        end
        __assert__(test, msg || default)
      end

      # Assert that an Array, or any other object the responds to #include?
      # thus contains the given element.
      #
      # @raise [Assertion] if test fails
      #
      # @return nothing
      def assert_includes(elem, array, msg=nil)
        test = array.include?(elem)
        msg = "Expected #{elem.inspect} is not found in #{array.inspect}" unless msg
        __assert__(test, msg)
      end

      # Flunk always fails.
      #
      # @example
      #   flunk 'Not done testing yet.'
      #
      # @raise [Assertion] always
      #
      # @return nothing
      def flunk(msg=nil)
        __assert__(false, msg)
      end

    end #module Assertions

  end #module Legacy

  module World
    include AE::Legacy::Assertions
  end

end


