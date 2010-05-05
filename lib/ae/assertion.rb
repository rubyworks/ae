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

  def self.recount
    $assertions = 0
    $failures   = 0
  end

  def self.count ; $assertions ; end
  def self.fails ; $failures   ; end

  #
  def initialize(message=nil, opts={})
    backtrace = opts[:backtrace]
    super(message)
    set_backtrace(backtrace) if backtrace
  end

  def to_s
    'fail ' + super
  end

end

# Copyright (c) 2008,2009 Thomas Sawyer
