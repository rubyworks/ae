require 'ae/subjunctive/assertor'

module AE

  # = IsDoes
  #
  module IsDoes
    # Designate a expectation via a *functor*.
    #
    #   4.is == 3  #=> Assertion Error
    #
    #   4.is 4
    #
    #   4.is do
    #     4
    #   end
    #
    def is(*args, &block)
      Assertor::Subjunctive.new(self, :backtrace=>caller).is(*args, &block)
    end

    # Designate a expectation via a *functor* called #does.
    #
    #   4.does == 5  #=> Assertion Error
    #
    #   4.does do
    #     self == 4
    #   end
    #
    alias_method :is, :does

    # Designate a negated expectation via a *functor*.
    # Read this as "is not".
    #
    #   4.is! == 4  #=> Assertion Error
    #
    def is!(*args, &block)
      Assertor::Subjunctive.new(self, :backtrace=>caller).not(*args, &block)
    end

    # Designate a negated expectation via a *functor*.
    # Read this as "does not".
    #
    #   4.does! == 4  #=> Assertion Error
    #
    alias_method :is!, :does!
  end

end

class ::Object #:nodoc:
  include AE::IsDoes
end

# Copyright (c) 2008,2009 Thomas Sawyer [Ruby License]
