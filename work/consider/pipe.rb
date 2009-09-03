require 'ae/assertion'

T = true
F = false

class AE

  module Kernel
    # This is just a little experiment.
    # If this pipe could be made to work
    # like assert 2.0, eg. report the entire
    # code section involved, the it could
    # actually be pretty cool.
    #
    #   x = "tom"
    #
    #   T* x == "tom"
    #
    #   F* x == "tom"  # raises Asseretion
    #
    #   T* case x
    #      when 'tom' then true
    #      else false
    #      end
    #
    module Pipe

      module True
        def *(x)
          raise Assertion.new(:backtrace=>caller) if !x
        end
      end

      module False
        def *(x)
          raise Assertion.new(:backtrace=>caller) if x
        end
      end
    end

  end

  class ::TrueClass #:nodoc:
    #remove_method :*
    include AE::Kernel::Pipe::True
  end

  class ::FalseClass #:nodoc:
    #remove_method :*
    include AE::Kernel::Pipe::False
  end

end

# examples

if __FILE__ == $0

  x = "tom"

#Give that x is "tom" then we can assert it
#is using an asseretion pipe.

  x = "tom"

  T* x == "tom"

#We can assert the opposite using F.

  F* x == "tom"

#These can be used at any point of return.

  T* case x
     when 'tom' then true
     else false
     end

end

