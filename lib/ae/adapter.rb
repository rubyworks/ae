if defined?(::Test::Unit)
  require 'ae/adapters/testunit'
elsif defined?(::MiniTest)
  require 'ae/adapters/minitest'
elsif defined?(::Spec)
  require 'ae/adapters/rspec'
end
