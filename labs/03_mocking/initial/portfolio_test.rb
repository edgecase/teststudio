#!/usr/bin/ruby -wKU

require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

require 'quote_service'
require 'portfolio'

class PortfolioTest < Test::Unit::TestCase
  def test_one_stock_returns_stock_value
    # write this test
  end

  def test_multiple_stocks_return_sum
    # write this test
  end

  def test_login_failure_returns_nil
    # write this test
  end

  def test_logout_failure_returns_good_value
    # write this test
  end

  def test_logout_must_be_called_if_login_succeeds
    # write this test
  end
  
  # NOTE: We don't have an explicit test for login/quote/logout
  # ordering.  Generally that's covered as part of the good path
  # testing. If you feel you need an explicit test for that, feel free
  # to add that test.

end
