# Expiremental Concept

#
class TrueClass
  # Assert true.
  #
  #   (x == y).true!
  #
  def true!
    true
  end
  # Assert false.
  #
  #   (x == y).false!
  #
  def false!
    fail Assertion.new('true', :backtrace=>caller)
  end
end

class FalseClass
  # Assert true.
  #
  #   (x == y).true!
  #
  def true!
    fail Assertion.new('false', :backtrace=>caller)
  end
  # Assert false.
  #
  #   (x == y).false!
  #
  def false!
    true
  end
end

