if defined?(::MiniTest)
  require 'ae/adapters/minitest'
elsif defined?(::Test::Unit)
  require 'ae/adapters/testunit'
elsif defined?(::RSpec)
  require 'ae/adapters/rspec'
end

