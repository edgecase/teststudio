require 'test/unit'
require 'fact'

class FactTest < Test::Unit::TestCase
  def test_factorial
    f = Factorial.new
    assert_equal 1, f.fact(0)
  end
end
