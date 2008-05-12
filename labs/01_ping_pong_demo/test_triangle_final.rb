#!/usr/bin/env ruby

require 'test/unit'

def classify_triangle(one, two, three)
  a,b,c = [one, two, three].sort
  uniq_sides = [a,b,c].uniq.size
  raise "This cannot be a triangle" if (a + b) == c
  if uniq_sides == 1
    :equilateral
  elsif uniq_sides == 2
    :isosceles
  else
    :scalene
  end
end

class TriangleTest < Test::Unit::TestCase
  def test_can_recognize_equalateral_triangles
    assert_equal :equilateral, classify_triangle(3,3,3)
  end

  def test_argument_order_does_not_matter
    assert_equal :scalene, classify_triangle(3,5,4)
    assert_equal :scalene, classify_triangle(3,4,5)
    assert_equal :scalene, classify_triangle(4,5,3)
  end

  def test_can_recognize_isosceles_triangles
    assert_equal :isosceles, classify_triangle(2,3,3)
    assert_equal :isosceles, classify_triangle(3,3,2)
    assert_equal :isosceles, classify_triangle(10, 10, 12)
  end

  def test_can_recognize_scalene_triangles
    assert_equal :scalene, classify_triangle(3,4,5)
  end

  def test_raises_exception_when_given_bad_values
    assert_raise RuntimeError do 
      classify_triangle(1,2,3)
    end
  end
end

