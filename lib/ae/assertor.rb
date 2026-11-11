require 'ae/assertion'
require 'ae/basic_object'
require 'ae/ansi'

module AE

  # Assertor is the underlying class of the whole system. It implements
  # the flutent assertion notation.
  #
  # An Assertor is an Assertion Functor. A Functor is a succinct name for what
  # is also known as Higher Order Function. In other words, it is a function
  # that acts on a function. It is very similiar to a delegator in most
  # respects, but is conditioned on the operation applied, rather then simply
  # passing-off to an alternate reciever.
  #
  class Assertor < AE::BasicObject

    # Initial settings of assertion counts.
    ZERO_COUNTS = {:total=>0,:pass=>0,:fail=>0}

    # Initialize assertion counts global variable.
    $ASSERTION_COUNTS = ZERO_COUNTS.dup

    # Returns Hash used to track assertion counts.
    def self.counts
      $ASSERTION_COUNTS
    end

    # Reset assertion counts.
    #
    # reset - Hash which can be used to set counts manually (optional).
    #
    # Returns the Hash of previous counts.
    def self.recount(reset=nil)
      old_counts = counts.dup
      if reset
        reset.each do |type, value|
          counts[type.to_sym] = value
        end
      else
        counts.replace(ZERO_COUNTS.dup)
      end
      return old_counts
    end

    # Increment assertion counts. If +pass+ is +true+ then +:total+
    # and +:pass+ are increased. If +pass+ if +false+ then +:total+ 
    # and +:fail+ are incremented.
    def self.increment_counts(pass)
      counts[:total] += 1
      if pass
        counts[:pass] += 1
      else
        counts[:fail] += 1
      end
      return counts
    end

    # Basic assertion. This method by-passes all the Assertor fluent
    # constructs and performs the underlying assertion procedure. It
    # is used by Assertor as the end call of an assertion.
    #
    # The +error+ can be a message, an exception, or a Proc that
    # returns either. A Proc is only called if the assertion fails,
    # which saves building a message that is never shown.
    def self.assert(pass, error=nil, negated=nil, backtrace=nil)
      pass = !!negated ^ !!pass
      increment_counts(pass)
      if !pass
        backtrace = backtrace || caller
        raise_assertion(error, negated, backtrace)
      end
      return pass
    end

    # The intent of the method is to raise an assertion failure
    # class that the test framework supports.
    def self.raise_assertion(error, negated, backtrace=nil)
      error = error.call if ::Proc === error
      if not ::Exception === error
        error = assertion_error.new(error)
      end
      error.set_negative(negated)
      error.set_backtrace(backtrace || caller)
      error.set_assertion(true)
      fail error
    end

    # Returns the Exception class to be raised when an assertion fails.
    def self.assertion_error
      ::Assertion
    end

    # NOT HAPPENING
    ## Is ::Assay defined. This is used for integration of the Assay library.
    #def self.assay?
    #  @_assay ||= defined?(::Assay)
    #end
    #
    #def self.message(sym, neg, *args, &blk)
    #  if method = Message.lookup(sym) 
    #    method = "non_#{method}" if neg
    #    Message.send(method, *args, &blk)
    #  else
    #    nil
    #  end
    #end

    # Ruby's BasicObject has a few public methods of its own, which would
    # answer a call themselves instead of making an assertion. Making
    # these private sends them through #method_missing like any other
    # method, so `x.assert.instance_eval { @a == 1 }` asserts something
    # about `x`. Only #__send__ and #__id__ stay public, because Ruby
    # relies on them.
    private :==, :!, :!=, :equal?, :instance_eval, :instance_exec

    # Methods with no arguments whose result is not true, false or nil
    # get a warning, once per line, because the result is probably
    # meant to be compared, as in `x.assert.size == 3`. That compares
    # the assertion's own result, true, and checks nothing.
    def self.chain_warning(where, message)
      @chain_warnings ||= {}
      return if @chain_warnings[where]
      @chain_warnings[where] = true
      ::Kernel.warn("#{where}: warning: #{message}")
    end

    # Color diffs are skipped when the two strings are this large
    # (the product of their lengths), because building one takes
    # time and memory in proportion.
    DIFF_LIMIT = 1_000_000

    # New Assertor.
    #
    def initialize(delegate, opts={}) #, backtrace)
      @delegate  = delegate
      @message   = opts[:message]
      @backtrace = opts[:backtrace] || caller #[1..-1]
      @negated   = !!opts[:negated]
    end

    # TODO: Should #not return a new Assertor instead of in place negation?

    # Negate the meaning of the assertion.
    #
    def not(msg=nil)
      @negated = !@negated
      @message = msg if msg
      self
    end

    # Internal assert, provides all functionality associated
    # with external #assert method. (See Assert#assert)
    #
    # NOTE: I'm calling YAGNI on using extra arguments to pass
    # to the block. The interface is much nicer if a macro is
    # created to handle any neccessry arguments. Eg.
    #
    #   assert something(parameter)
    #
    # instead of
    #
    #   assert something, parameter
    #
    # Returns +true+ or +false+ based on assertions success.
    #
    def assert(*args, &block)
      return self if !block && args.empty?

      # Block
      if block
        result = block.arity > 0 ? block.call(@delegate) : block.call
        if args.empty?
          return __assert__(result) { @message || block.inspect }
        else
          # Any expected value counts, even false or nil.
          match = args.shift
          return __assert__(match == result) { @message || "#{__inspect__(match)} == #{__inspect__(result)}" }
        end
      end

      target = args.shift

      # Proc-style
      if proc_assertion?(target)
        pass, error = proc_apply(target)

      # Assay-style assertions
      #elsif assay_assertion?(target)
      #  pass, error = assay_assertion_apply(target)

      # RSpec-style matchers
      elsif rspec_matcher?(target)
        pass, error = rspec_matcher_apply(target)

      # Truthiness
      else
        pass  = target     # truthiness
        error = args.shift # optional message for TestUnit compatiability
      end

      __assert__(pass, error)
    end

    # TODO: Should we deprecate the receiver matches in favor of #expected ?
    # In other words, should <code>|| @delegate</code> be dropped?

    # Internal expect, provides all functionality associated
    # with external #expect method. (See Expect#expect)
    #
    def expect(*args, &block)
      return self if !block && args.empty?  # same as #assert

      pass  = false
      error = nil

      if block
        # Any expected value counts, even false or nil.
        match = args.empty? ? @delegate : args.shift  # TODO: see above
        if exception?(match)
          # An exception instance stands for its class.
          klass = ::Class === match ? match : match.class
          $DEBUG, debug = false, $DEBUG  # b/c it always spits-out a NameError
          begin
            block.arity > 0 ? block.call(@delegate) : block.call
            pass  = false
            error = "#{klass} not raised"
          rescue klass
            pass  = true
            error = "#{klass} raised"
          rescue ::SignalException, ::SystemExit, ::NoMemoryError
            raise
          rescue ::Exception => e
            pass  = false
            error = "#{klass} expected but #{e.class} was raised: #{e.message}"
          ensure
            $DEBUG = debug
          end
          error = @message || error
        else
          result = block.arity > 0 ? block.call(@delegate) : block.call
          pass   = (match === result)
          error  = ::Kernel.proc { @message || "#{__inspect__(match)} === #{__inspect__(result)}" }
        end

      ## Matcher
      #elsif target.respond_to?(:matches?)
      #  pass  = target.matches?(@delegate)
      #  error = @message || matcher_message(target) #|| target.inspect
      #  if target.respond_to?(:exception)
      #    #error_class = target.failure_class
      #    error = target.exception #failure(:backtrace=>@backtrace, :negated=>@negated)
      #  end

      # Case Equality
      else
        target = args.shift
        pass   = (target === @delegate)
        error  = ::Kernel.proc { @message || "#{__inspect__(target)} === #{__inspect__(@delegate)}" }
      end

      __assert__(pass, error)
    end

    # Fail, whether or not the assertion is negated.
    def flunk(message=nil, backtrace=nil)
      Assertor.assert(false, message || @message, false, backtrace || @backtrace)
    end

    # Ruby seems to have a quark in it's implementation whereby
    # this must be defined explicitly, otherwise it somehow
    # skips #method_missing.
    def =~(match)
      method_missing(:"=~", match)
    end

    #
    def send(op, *a, **kw, &b)
      method_missing(op, *a, **kw, &b)
    end

    #
    def inspect
      @delegate.inspect
    end

   private

    # AE-STYLE ASSERTIONS

    # Is `target` a Proc, or any other object that responds to #call?
    # A Hash or Symbol is a value like any other, even though it has
    # #to_proc.
    def proc_assertion?(target)
      ::Proc === target || target.respond_to?(:call)
    end

    #
    def proc_apply(target)
      arity = (::Proc === target || ::Method === target) ? target.arity : target.method(:call).arity
      pass  = arity != 0 ? target.call(@delegate) : target.call
      error = ::Kernel.proc {
        @message || (
          to_s = target.method(:to_s)
          to_s.arity == 0 ? to_s.call : to_s.call(@negated)
        )
      }
      return pass, error
    end

    # ASSAY-STYLE ASSERTIONS
    # (not yet supported b/c api is not 100%)

    # Is the `assertion` object an assay-style assertion?
    def assay_assertion?(assertion)
      assertion.respond_to?(:exception) && assertion.respond_to?(:pass?)
    end

    #
    def assay_assertion_apply(assay)
      if @negated
        pass  = assay.fail?(@delegate)
        error = assay #.exception(@message || )
      else
        pass  = assay.pass?(@delegate)
        error = assay #.exception(@message || )
      end
      return pass, error
    end

    # RSPEC-STYLE MATCHERS

    # Is `target` an Rspec-style Matcher?
    def rspec_matcher?(target)
      target.respond_to?(:matches?)
    end

    #
    def rspec_matcher_apply(matcher)
      pass  = matcher.matches?(@delegate)
      error = ::Kernel.proc { @message || rspec_matcher_message(matcher) }
      return pass, error
    end

    # TODO: Is there anything to be done with matcher.description?

    #
    def rspec_matcher_message(matcher)
      if @negated
        if matcher.respond_to?(:failure_message_for_should_not)
          return matcher.failure_message_for_should_not
        end
        if matcher.respond_to?(:negative_failure_message)
          return matcher.negative_failure_message
        end
      end

      if matcher.respond_to?(:failure_message_for_should)
        return matcher.failure_message_for_should
      end
      if matcher.respond_to?(:failure_message)
        return matcher.failure_message
      end

      return matcher.to_s  # TODO: or just `nil` ?
    end

    # TODO: Should we use a more libreral determination of exception.
    # e.g. <code>respond_to?(:exception)</code>.

    # Is the +object+ an Exception class or an instance of one?
    def exception?(object)
      ::Exception === object || (::Class === object && object <= ::Exception)
    end

    # TODO: In future should probably be `@delegate.public_send(sym, *a, &b)`.

    # Converts a missing method into an Assertion.
    def method_missing(sym, *args, **kw, &block)
      pass = @delegate.__send__(sym, *args, **kw, &block)

      if args.empty? && kw.empty? && !block
        __chain_warning__(sym, pass)
      end

      __assert__(pass) do
        @message || compare_message(sym, *args) || generic_message(sym, *args, **kw)
      end
    end

    # TODO: Can the handling of the message be simplified/improved?

    # Simple assert. The failure message can be given as a block,
    # which is only called if the assertion fails.
    def __assert__(pass, error=nil, &message)
      Assertor.assert(pass, error || message, @negated, @backtrace)
    end

    # Warn about `x.assert.size == 3`, which checks only that `size`
    # is truthy. See Assertor.chain_warning.
    def __chain_warning__(sym, result)
      return if ::TrueClass === result || ::FalseClass === result || ::NilClass === result
      name = sym.to_s
      return unless /\A[a-z_]\w*\z/i.match?(name)
      where = @backtrace.first.to_s.sub(/:in .*\z/, '')
      value = __inspect__(result)
      value = value[0, 40] + '...' if value.size > 43
      Assertor.chain_warning(where,
        "`#{name}` returned #{value}, so AE only checked that it was truthy. " \
        "To compare the result, write `object.#{name}.assert == expected`."
      )
    end

    # The object's #inspect, or a plain description of it if #inspect
    # is missing or broken. A failure message shouldn't fail itself.
    def __inspect__(object)
      object.inspect
    rescue ::StandardError
      ::Kernel.instance_method(:to_s).bind_call(object)
    end

    #
    COMPARISON_OPERATORS = { :"==" => :"!=" }

    # Message to use when making a comparion assertion.
    #
    # NOTE: This message utilizes the ANSI gem to produce colorized
    # comparisons, when standard output is a terminal and NO_COLOR is
    # not set. To choose for yourself, set `AE.ansi = false` (or true)
    # in your test helper.
    #
    # @param operator [Symbol] operator/method
    #
    # @see https://rubyworks.github.io/ansi
    def compare_message(operator, *args, &blk)
      return nil unless COMPARISON_OPERATORS.key?(operator)
      prefix = ""
      a, b = __inspect__(@delegate), __inspect__(args.first)
      if @negated
        op = COMPARISON_OPERATORS[operator]
        if op
          operator = op
        else
          prefix   = "NOT "
        end
      end
      if AE.ansi? && a.size * b.size <= DIFF_LIMIT
        diff = ::ANSI::Diff.new(a,b)
        a = diff.diff1
        b = diff.diff2
      end
      if a.size > 13 or b.size > 13
        prefix + "a #{operator} b\na) " + a + "\nb) " + b
      else
        prefix + "#{a} #{operator} #{b}"
      end
    end

    # Puts together a suitable error message.
    #
    # @param op [Symbol] operator/method
    #
    # @return [String] message
    def generic_message(op, *a, **kw, &b)
      inspection = __inspect__(@delegate)
      list = a.map { |x| __inspect__(x) } + kw.map { |k, v| "#{k}: #{__inspect__(v)}" }
      if @negated
        "! #{inspection} #{op} #{list.join(',')}"
      else
        "#{inspection} #{op} #{list.join(',')}"
      end
      #self.class.message(m)[@delegate, *a] )
    end

    # @see http://redmine.ruby-lang.org/issues/3768
    def self.const_missing(const)
     ::Object.const_get(const)
    end
  end

end

# DO WE MAKE THESE EXCEPTIONS?
#class BasicObject
#  def assert
#  end
#end

# Copyright (c) 2008 Thomas Sawyer
