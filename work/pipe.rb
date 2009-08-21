require 'assertion'

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
    #   T | x == "tom"
    #
    #   F | x == "tom"  # raises Asseretion
    #
    #   T | case x
    #       when 'tom' then true
    #       else false
    #       end
    #
    module Pipe

      module True
        def |(x)
          raise Assertion if !x
        end
      end

      module False
        def |(x)
          raise Assertion if x
        end
      end
    end

  end

  class ::TrueClass #:nodoc:
    remove_method :|
    include AE::Expression::Pipe::True
  end

  class ::FalseClass #:nodoc:
    remove_method :|
    include AE::Expression::Pipe::False
  end

end

# examples

if __FILE__ == $0

  x = "tom"

  T | x == "tom"
  F | x == "tom"

  T | case x
      when 'tom' then true
      else false
      end

end
