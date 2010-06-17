require 'yaml'

module AE
  DIRECTORY = File.dirname(__FILE__) + '/ae'

  PROFILE = YAML.load(File.new(DIRECTORY + '/profile.yml')) rescue {}
  PACKAGE = YAML.load(File.new(DIRECTORY + '/package.yml')) rescue {}

  VERSION = PACKAGE.values_at('major','minor','patch','build').compact.join('.')

  #
  def self.const_missing(name)
    key = name.to_s.downcase
    if PACKAGE.key?(key)
      PACKAGE[key]
    elsif PROFILE.key?(key)
      PROFILE[key]
    else
      super(name)
    end
  end
end

require 'ae/assert'
require 'ae/expect'

# Copyright (c) 2008 Thomas Sawyer
