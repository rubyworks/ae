require 'yaml'

module AE
  DIRECTORY = File.dirname(__FILE__) + '/ae'

  profile = YAML.load(File.new(DIRECTORY + '/profile.yml')) rescue {}
  verfile = YAML.load(File.new(DIRECTORY + '/version.yml')) rescue {}

  VERSION = verfile.values_at('major','minor','patch','state','build').compact.join('.')

  #
  def self.const_missing(name)
    key = name.to_s.downcase
    if verfile.key?(key)
      verfile[key]
    elsif profile.key?(key)
      profile[key]
    else
      super(name)
    end
  end
end

require 'ae/assert'
require 'ae/expect'

# Copyright (c) 2008 Thomas Sawyer
