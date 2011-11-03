require 'ae/basic_object'

module Kernel

  # TODO: Is th cache really neccessry?

  #
  $PRY_TABLE = {}

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
    $PRY_TABLE[self] ||= Pry.new do |op, *a, &b|
      __send__(op, *a, &b)
    end
  end

  # Pry Functor
  class Pry < AE::BasicObject
    #instance_methods.each{ |m| private m unless m.to_s =~ /^__/ }
    def initialize(&function)
      @function = function
    end
    def method_missing(op, *a, &b)
      @function.call(op, *a, &b)
    end
  end

end

