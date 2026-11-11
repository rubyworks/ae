require 'ae/basic_object'

module Kernel

  # Pry allows you to test private and protected methods
  # thru a public-only interface.
  #
  # Generally one should avoid testing private and protected
  # methods directly, instead relying on tests of public methods to
  # indirectly test them, because private and protected methods are
  # considered implementation details. But sometimes it is necessary
  # to test them directly, or if you wish to achieve *absolute
  # coverage*, say in a mission critical system.
  #
  # @return [Pry] pry functor
  def pry
    Pry.new do |op, *a, **kw, &b|
      __send__(op, *a, **kw, &b)
    end
  end

  # Pry Functor
  class Pry < AE::BasicObject
    # Send these to the object too, rather than answering them here.
    private :==, :!, :!=, :equal?, :instance_eval, :instance_exec

    def initialize(&function)
      @function = function
    end

    def method_missing(op, *a, **kw, &b)
      @function.call(op, *a, **kw, &b)
    end
  end

end
