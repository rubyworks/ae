# Expiremental Concept

class TrueClass
  def true
    true
  end
  def false
    fail Assertion.new('true', :backtrace=>caller)
    #raise Assertion
  end
end

class FalseClass
  def true
    fail Assertion.new('false', :backtrace=>caller)
  end
  def false
    true
  end
end

