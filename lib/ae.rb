module AE
  vers = YAML.load(File.read(File.dirname(__FILE__) + '/ae/version.yml'))
  VERSION = vers.values_at('major', 'minor', 'patch', 'state', 'build').compact.join('.')
end

require 'ae/assert'
require 'ae/expect'

# Copyright (c) 2008 Thomas Sawyer
