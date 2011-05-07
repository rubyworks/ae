require 'ansi/diff'

module AE

  # Base class for custom messages.
  module Message
    extend self

    # Store Hash of +operator+ => +method+ entries.
    def self.registry
      @registry ||= {}
    end

    # Look-up message method.
    def self.lookup(operator)
      if method = registry[operator]
        method
      elsif method_defined?(operator)
        operator
      end
    end

    # Set an operator's message method.
    def self.operator(operator, method)
      registry[operator] = method
    end

    # Message for `==` assertions.
    def equality(a,b)
      if a.size > 13 or b.size > 13
        diff = ANSI::Diff.new(a,b)
        "a == b\na) " + diff.diff1 + "\nb) " + diff.diff2
      else
        "#{a.inspect} == #{b.inspect}"
      end     
    end

    # Message for `!=` assertions.
    def non_equality(a,b)
      if a.size > 13 or b.size > 13
        diff = ANSI::Diff.new(a,b)
        "a != b\na) " + diff.diff1 + "\nb) " + diff.diff2
      else
        "#{a.inspect} != #{b.inspect}"
      end     
    end

    operator :==, :equality

    # Message for `=~` assertion.
    def case_equality(a,b)
      "#{a.inspect} =~ #{b.inspect}"
    end

    # Message for `!~` assertion.
    def non_case_equality(a,b)
      "#{a.inspect} !~ #{b.inspect}"
    end

    operator :=~, :case_equality
  end

end
