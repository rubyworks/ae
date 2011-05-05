require 'test/unit'
#require 'assay'
require 'ae/adapters/testunit'

class TestUnitSupport < Test::Unit::TestCase

  def test_assert_pass
    x = 5
    y = 5
    x.assert == y
  end

  def test_assert_fail
    x = "12345678901234567890"
    y = "123456789X1234567890"
    x.assert == y
  end

  def test_assert_fail_original
    x = 5
    y = 6
    assert_equal(x, y)
  end

  def test_assert_pass_original
    x = 5
    y = 5
    assert_equal(x, y)
  end

  def test_exception
    raise
  end

end
