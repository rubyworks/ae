require 'ae'

class Assertion

  def self.framework_flunk(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = Spec::Expectations::ExpectationNotMetError.new(message)
    err.set_backtrace(options[:backtrace]) if options[:backtrace]
    fail err
  end

end
