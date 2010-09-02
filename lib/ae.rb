require 'yaml'

module AE
  DIRECTORY = File.dirname(__FILE__) + '/ae'

  PROFILE = YAML.load(File.new(DIRECTORY + '/meta/profile')) rescue {}
  PACKAGE = YAML.load(File.new(DIRECTORY + '/meta/package')) rescue {}

  VERSION = PACKAGE['version']

  #
  def self.const_missing(name)
    key = name.to_s.downcase
    PACAKGE[key] || PROFILE[key] || super(name)
  end
end

require 'ae/assert'
require 'ae/expect'

# Copyright (c) 2008 Thomas Sawyer
