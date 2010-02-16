#!/usr/bin/ruby -wKU

require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

require 'portfolio'

class PortfolioTest < Test::Unit::TestCase
  def setup
    @quote_service = flexmock("quote service")
    @quote_service.should_receive(:login => true, :logout => nil).by_default
    flexmock(QuoteService).should_receive(:new).and_return(@quote_service)
  end

  def test_one_stock_returns_stock_value
    @quote_service.should_receive(:quote).with("APPL").and_return(100).once
    port = Portfolio.new
    port.add_stock("APPL")

    actual = port.value

    assert_equal 100, actual
  end

  def test_multiple_stocks_return_sum_of_values
    @quote_service.should_receive(:quote).with("APPL").and_return(100).once
    @quote_service.should_receive(:quote).with("GOOG").and_return(20).once
    port = Portfolio.new
    port.add_stock("APPL")
    port.add_stock("GOOG")

    actual = port.value

    assert_equal 120, actual
  end

  def test_must_login_and_logout
    @quote_service.should_receive(:login).with("user", "pw").once.ordered
    @quote_service.should_receive(:quote).with("APPL").and_return(100).once.ordered(:quoting)
    @quote_service.should_receive(:quote).with("GOOG").and_return(20).once.ordered(:quoting)
    @quote_service.should_receive(:logout).with().once.ordered
    
    port = Portfolio.new
    port.add_stock("APPL")
    port.add_stock("GOOG")

    actual = port.value

    assert_equal 120, actual
  end

  def test_quote_returns_nil_on_login_failure
    @quote_service.should_receive(:login).and_raise(StandardError)
    @quote_service.should_receive(:quote).never
    @quote_service.should_receive(:logout).never
    
    port = Portfolio.new
    port.add_stock("APPL")

    actual = port.value

    assert_equal nil, actual
  end

  def test_quote_returns_good_value_on_logout_failure
    @quote_service.should_receive(:quote => 100)
    @quote_service.should_receive(:logout).and_raise(StandardError)
    
    port = Portfolio.new
    port.add_stock("APPL")

    actual = port.value

    assert_equal 100, actual
  end
end
