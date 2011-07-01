module AE

  # Set Assertion class. This is a convenience method
  # for framework adapters, used to set the exception class
  # that a framework uses to raise an assertion error.
  #
  # @param [Class]
  #   The Exception class use to raise Assertions.
  #
  def self.assertion_error=(exception_class)
    verbose, $VERBOSE = $VERBOSE, nil
    Object.const_set(:Assertion, exception_class)
    $VERBOSE = verbose
  end

  # Default ANSI mode is "on".
  @ansi = true

  # ANSI mode.
  #
  # @return [Boolean] ANSI mode.
  def self.ansi?
    @ansi
  end

  # To turn of ANSI colorized error messages off, set 
  # ansi to +false+ in your test helper.
  #
  # @example
  #   AE.ansi = false
  #
  def self.ansi=(boolean)
    @ansi = boolean
  end

end

require 'ae/version'
require 'ae/assert'
require 'ae/expect'

