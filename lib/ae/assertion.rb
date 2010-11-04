require 'ae/core_ext'

# = Assertion
#
#   "The reserve of modern assertions is sometimes pushed to extremes,
#    in which the fear of being contradicted leads the writer to strip
#    himself of almost all sense and meaning."
#                              -- Sir Winston Churchill (1874 - 1965)
#
# This is the underlying Exception class of the whole system.
#
class Assertion < Exception

  # TODO: This doesn't seem to cut it anymore!
  @count = 0
  @fails = 0

  class << self
    attr_accessor :count
    attr_accessor :fails

    #
    def test(test, options={})
      if test
        increment(true)
      else
        framework_flunk(options)
      end
      test
    end

    #
    #def self.framework_assert(options={})
    #end

    # This method can be replaced to support alternate frameworks.
    # The intent of the methods is to raise the assertion failure
    # class used.
    def framework_flunk(options={})
      message = options.delete(:message)
      fail ::Assertion.new(message, options)
    end

    # Increment assertion counts. If +pass+ is true then only +@count+
    # is increased. If +pass+ if false then both +@count+ and +@fails+
    # are incremented.
    def increment(pass)
      recount unless instance_variable_defined?('@count') # TODO: Come on, there has to be a better way!
      @count += 1
      @fails += 1 unless pass
    end

    # Reset counts.
    def recount
      f, c = @fails, @count
      @count = 0
      @fails = 0
      return f, c
    end
  end

  #
  def initialize(message=nil, options={})
    super(message)
    backtrace = options[:backtrace]
    set_backtrace(backtrace) if backtrace
    self.class.increment(false)
  end

  #
  def to_s
    'fail ' + super
  end

end

# Copyright (c) 2008, 2010 Thomas Sawyer
