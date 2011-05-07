# Expiremental Nomenclature.

#
class TrueClass
  # Assert true.
  #
  #   (x == y).true!
  #
  def true!(msg=nil)
    true
  end
  # Assert false.
  #
  #   (x == y).false!
  #
  def false!(err="not false")
    if Exception === err
      fail err
    else
      fail Assertion.new(err.to_s, :backtrace=>caller)
    end
  end
end

class FalseClass
  # Assert true.
  #
  #   (x == y).true!
  #
  def true!(err="not true")
    if Exception === err
      fail err
    else
      fail Assertion.new(err.to_s, :backtrace=>caller)
    end
  end
  # Assert false.
  #
  #   (x == y).false!
  #
  def false!(msg=nil)
    true
  end
end

