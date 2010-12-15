# AE, Copyright (c) 2008 Thomas Sawyer
module AE
  #
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/ae.yml'))
    )
  end

  #
  def self.const_missing(name)
    key = name.to_s.downcase
    metadata[key] || super(name)
  end

  # becuase Ruby 1.8~ gets in the way :(
  VERSION = metadata['version']
end

require 'ae/assert'
require 'ae/expect'
