require 'ae'

module Kernel

  def raise_assertion(options)
    message   = options.delete(:message)
    backtrace = options.delete(:backtrace)

    err = Spec::Expectations::ExpectationNotMetError.new(message)
    err.set_backtrace(options[:backtrace]) if options[:backtrace]
    fail err
  end

end
