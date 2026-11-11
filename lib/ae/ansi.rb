require 'ansi/diff'

module AE

  # ANSI mode is automatic until it is set: on when standard output is
  # a terminal and the NO_COLOR environment variable is not set.
  @ansi = nil

  # ANSI mode.
  #
  # @return [Boolean] ANSI mode.
  def self.ansi?
    return @ansi unless @ansi.nil?
    $stdout.respond_to?(:tty?) && $stdout.tty? && ENV.fetch('NO_COLOR', '').empty?
  end

  # To turn ANSI colorized error messages on or off, set
  # ansi to +true+ or +false+ in your test helper. Set it to
  # +nil+ to go back to the automatic setting.
  #
  # @example
  #   AE.ansi = false
  #
  def self.ansi=(boolean)
    @ansi = boolean.nil? ? nil : !!boolean
  end

end
