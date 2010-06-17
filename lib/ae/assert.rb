require 'ae/assertor'

module AE

  # = Assert
  #
  module Assert

    # Assert a operational relationship.
    #
    #   4.assert == 3
    #
    # If only a single test argument is given then
    # #assert simple validates that it evalutate to true.
    # An optional message argument can be given in this
    # case which will be used instead of the deafult message.
    #
    #   assert(4==3, "not the same thing")
    #
    # In block form, #assert ensures the block evalutes
    # truthfully, i.e. not as nil or false.
    #
    #   assert{ 4==3 }
    #
    def assert(*args, &block)
      Assertor.new(self, :backtrace=>caller).assert(*args, &block)
    end

    # Same as 'object.assert == other'.
    def assert=(cmp)
      Assertor.new(self, :backtrace=>caller).assert(*args, &block) == cmp
    end

    # Assert not an operational relationship.
    # Read it as "assert not".
    #
    #   4.assert! == 4
    #
    # See #assert.
    #
    # AUHTOR'S NOTE: This method would not be necessary if Ruby would allow
    # +!=+ to be define as a method, or at least +!+ as a unary method. This
    # may be possible in Ruby 1.9.
    #
    def assert!(*args, &block)
      Assertor.new(self, :backtrace=>caller).not.assert(*args, &block)
    end

    # Alias for #assert!.
    #
    # 4.refute == 4  #=> Assertion Error
    #
    alias_method :refute, :assert!
  end

end

class ::Object #:nodoc:
  include AE::Assert
end

# Copyright (c) 2008,2009 Thomas Sawyer
