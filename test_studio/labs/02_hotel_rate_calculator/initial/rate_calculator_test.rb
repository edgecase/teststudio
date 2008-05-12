#!/usr/bin/env ruby

require 'test/unit'
require 'rate_calculator'

######################################################################
class RateCalculatorTest < Test::Unit::TestCase

  def test_default_rate
    assert_equal 100, RateCalculator.new.rate(nil, nil, nil)
  end

end

