module Kernel

  def true?
    TrueClass === self
  end

  def false?
    FalseClass === self
  end

  def identical?(exp)
    exp.object_id == object_id
  end

  # Broad equality.
  def equate?(x)
    equal?(x) || eql?(x) || self == x || self === x
  end

  #
  def send?(method, *args, &block)
    begin
      __send__(method, *args, &block)
      true
    rescue
      false
    end
  end

  #
  def returns?(value) #:yield:
    value == yield
  end

end


class Numeric

  # Is self and given number within delta tolerance.
  #
  #   0.05.in_delta?(50000.0 / 10**6, 0.00001)
  #
  def in_delta?(num, delta)
    (num.to_f - to_f).abs <= delta.to_f
  end

end


class Proc

  def raise?(exception=Exception, *args)
    begin
      call(*args)
      false
    rescue exception => err
      exp === err
    end
  end

  def throw?(symbol, *args)
    catch(sym) do
      begin
        call(*args)
        true
      rescue ArgumentError => err     # 1.9 exception
        #msg += ", not #{err.message.split(/ /).last}"
        false
      rescue NameError => err         # 1.8 exception
        #msg += ", not #{err.name.inspect}"
        false
      end
    end
  end

end

class Symbol

  # Does the block throw the symbol?
  # 
  def thrown?
    catch(self) do
      begin
        yield
        true
      rescue ArgumentError => err     # 1.9 exception
        #msg += ", not #{err.message.split(/ /).last}"
        false
      rescue NameError => err         # 1.8 exception
        #msg += ", not #{err.name.inspect}"
        false
      end
    end
  end

end

class Exception

  def self.raised? #:yeild:
    begin
      yield
      false
    rescue self
      true
    end
  end

end

# hack
NoArgument = Object.new

