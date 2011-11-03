module AE

  # TODO: Should we really be reseting a constant for ::Assertion?
  # How about using a variable instead?

  # Set Assertion class. This is a convenience method
  # for framework adapters, used to set the exception class
  # that a framework uses to raise an assertion error.
  #
  # @param [Class] exception_class
  #   The Exception subclass used to raise assertions.
  #
  def self.assertion_error=(exception_class)
    verbose, $VERBOSE = $VERBOSE, nil
    Object.const_set(:Assertion, exception_class)
    $VERBOSE = verbose
  end

end

require 'ae/version'
require 'ae/assert'
require 'ae/expect'

class ::Object
  include AE::Assert
  include AE::Expect
end

