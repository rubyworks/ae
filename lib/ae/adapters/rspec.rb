require 'ae'

AE.assertion_error = ::RSpec::Expectations::ExpectationNotMetError

# TODO: Teach RSpec the expanded concept of assertions, as Exception
# classes that respond to `#assertion?` in the affirmative.

