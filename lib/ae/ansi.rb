require 'ansi/diff'

module AE

  # Default ANSI mode is "on".
  @ansi = true

  # ANSI mode.
  #
  # @return [Boolean] ANSI mode.
  def self.ansi?
    @ansi
  end

  # To turn of ANSI colorized error messages off, set 
  # ansi to +false+ in your test helper.
  #
  # @example
  #   AE.ansi = false
  #
  def self.ansi=(boolean)
    @ansi = boolean
  end

end

