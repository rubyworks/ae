# Framework Adapters

AE works within other test frameworks by way of adapters. An adapter
makes AE raise the framework's own assertion error, so a failed AE
assertion is reported as a failure rather than an error, and it adds
each AE assertion to the framework's count. Requiring `ae/adapter`
loads the adapter for whichever framework is already loaded.

To see them at work, we run a small test under each framework in a
separate Ruby process.

    require 'rbconfig'

    lib = File.dirname($LOADED_FEATURES.grep(%r{/ae\.rb\z}).first)

    run = lambda do |code|
      IO.popen([RbConfig.ruby, '-I', lib, '-e', code, err: [:child, :out]], &:read)
    end


## Minitest

    output = run.call <<~'RUBY'
      require 'minitest/autorun'
      require 'ae/adapter'

      class ExampleTest < Minitest::Test
        def test_pass; 5.assert == 5; end
        def test_fail; 5.assert == 6; end
      end
    RUBY

    output.assert.include?("2 runs, 2 assertions, 1 failures, 0 errors")


## Test::Unit

    output = run.call <<~'RUBY'
      require 'test/unit'
      require 'ae/adapter'

      class ExampleTest < Test::Unit::TestCase
        def test_pass; 5.assert == 5; end
        def test_fail; 5.assert == 6; end
      end
    RUBY

    output.assert.include?("2 tests, 2 assertions, 1 failures, 0 errors")
