if defined?(::Minitest::Test)
  require 'ae/adapters/minitest'
elsif defined?(::Test::Unit::TestCase)
  require 'ae/adapters/testunit'
elsif defined?(::RSpec::Expectations)
  require 'ae/adapters/rspec'
end
