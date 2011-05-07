class Exception
  # Is this exception the result of an assertion?
  def assertion?
    @assertion || false
  end

  # Set +true+/+false+ if the this exception is 
  # an assertion.
  def set_assertion(boolean)
    @assertion = !!boolean
  end

  #
  def negative?
    @negative || false
  end

  #
  def set_negative(boolean)
    @negative = !!boolean
  end
end

