# Nearly all, if not all, of these core extension are available from Ruby Facets.

# hack
NoArgument = Object.new

module Kernel
  # Is literally true.
  def true?
    TrueClass === self
  end

  # Is literally false.
  def false?
    FalseClass === self
  end

  # Are identical, eg. object_id's are equal.
  def identical?(exp)
    exp.object_id == object_id
  end

  # Alias for #identical?
  alias_method :identical_to?, :identical?

  # Word form of #==. Also can take a block.
  def eq?(value=NoArgument) #:yield:
    if block_given?
      self == yield
    else
      self == value
    end
  end

  # Word form of #===. Also can take a block.
  def case?(value=NoArgument) #:yield:
    if block_given?
      self === yield
    else
      self === value
    end
  end

  # Word form for #=~. Also can take a block.
  def match?(value=NoArgument)
    if block_given?
      self =~ yield
    else
      self =~ value
    end
  end

  # Broad equality.
  def equate?(x)
    equal?(x) || eql?(x) || self == x || self === x
  end

  # Can a message be sent to the receiver successfully?
  def send?(method, *args, &block)
    begin
      __send__(method, *args, &block)
      true
    rescue NoMethodError
      false
    end
  end

  #
  #def returns?(value) #:yield:
  #  value == yield
  #end

  unless method_defined?(:public_send)
    #
    def public_send(m,*a,&b)
      raise NoMethodError unless respond_to?(m)
      __send__(m,*a,&b)
    end
  end
end


class Object
  # Allows equal? to take a block.
  def equal?(value=NoArgument) #:yield:
    if block_given?
      super(yield)
    else
      super
    end
  end

  # Allows eql? to take a block.
  def eql?(value=NoArgument) #:yield:
    if block_given?
      super(yield)
    else
      super
    end
  end
end

class Numeric
  # Is self and given number within delta tolerance.
  #
  #   0.05.in_delta?(50000.0 / 10**6, 0.00001)
  #
  def in_delta?(orig, delta=0.001)
    #(num.to_f - to_f).abs <= delta.to_f
    delta >= (orig - self).abs
  end

  # Alias for #in_delta.
  alias_method :close?, :in_delta?

  # Verify epsilon tolerance.
  def in_epsilon?(orig, epsilon=0.001)
    in_delta?(orig, [orig, self].min * epsilon)
  end
end


class Module
  # Is a given class or module an ancestor of this
  # class or module?
  #
  #  class X ; end
  #  class Y < X ; end
  #
  #   Y.is?(X)  #=> true
  #
  def is?(base)
    Module===base && ancestors.slice(1..-1).include?(base)
  end
end

class Proc
  #
  def raises?(exception=Exception, *args)
    begin
      call(*args)
      false
    rescue exception => error
      exception === error
    end
  end

  #
  def throws?(sym, *args)
    catch(sym) do
      begin
        call(*args)
      rescue ArgumentError  # 1.9 exception
      rescue NameError      # 1.8 exception
      end
      return false
    end
    return true
  end

  # TODO: Put in facets?
  # TODO: wrong place, change yield?
  def change?
    pre_result = yield
    called = call
    post_result = yield
    pre_result != post_result
  end
end

class Symbol
  # Does the block throw this symbol?
  #
  def thrown?(*args)
    catch(self) do
      begin
        yield(*args)
      rescue ArgumentError  # 1.9 exception
      rescue NameError      # 1.8 exception
      end
      return false
    end
    return true
  end
end

class Exception
  #
  def self.raised? #:yeild:
    begin
      yield
      false
    rescue self
      true
    end
  end
end

# Copyright (c) 2008,2009 Thomas Sawyer
