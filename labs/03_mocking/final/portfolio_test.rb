#!/usr/bin/ruby -wKU

require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

require 'portfolio'

class PortfolioTest < Test::Unit::TestCase
  def test_one_stock_returns_stock_value
    port = Portfolio.new
    port.add_stock("APPL")

    actual = port.value

    assert_equal 100, actual
  end
end
