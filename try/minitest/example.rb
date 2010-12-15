require 'minitest/autorun'
require 'ae/adapters/minitest'

class MiniTestSupport < MiniTest::Unit::TestCase

  def test_assert_pass
    x = 5
    y = 5
    x.assert == y
  end

  def test_assert_fail
    x = 5
    y = 6
    x.assert == y
  end

  def test_assert_pass_original
    x = 5
    y = 5
    assert_equal(x, y)
  end

  def test_assert_fail_original
    x = 5
    y = 6
    assert_equal(x, y)
  end

  def test_exception
    raise "This should raise an exception."
  end

end
