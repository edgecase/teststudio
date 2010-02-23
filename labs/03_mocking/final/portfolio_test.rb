#!/usr/bin/ruby -wKU

require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

require 'quote_service'
require 'portfolio'

class PortfolioTest < Test::Unit::TestCase
  def setup
    @quote_mock = flexmock("quote svc")
    flexmock(QuoteService).should_receive(:new).and_return(@quote_mock)
    @port = Portfolio.new
  end
  
  def setup_quote_service(opts={})
    @quote_mock.should_receive(:login).with("USER", "PASSWORD").
      once.ordered(:first)
    yield
    unless opts[:explicit] == :logout
      @quote_mock.should_receive(:logout).once.ordered(:last)
    end
  end
  
  def expect_stock(name, value)
    @port.add_stock(name)
    @quote_mock.should_receive(:quote).with(name).
      and_return(value).once.ordered(:logged_in)
  end
  
  def test_one_stock_returns_stock_value
    setup_quote_service do
      expect_stock("APPL", 100)
    end

    assert_equal 100, @port.value
  end

  def test_multiple_stocks_return_sum
    setup_quote_service do
      expect_stock("APPL", 100)
      expect_stock("GOOG", 20)
    end

    assert_equal 120, @port.value
  end

  def test_login_failure_returns_nil
    @quote_mock.should_receive(:login).and_raise(StandardError)
    @quote_mock.should_receive(:quote).never
    @quote_mock.should_receive(:logout).never

    assert_nil @port.value
  end

  def test_logout_failure_returns_good_value
    setup_quote_service(:explicit => :logout) do
      expect_stock("APPL", 100)
      expect_stock("APPL", 20)
      @quote_mock.should_receive(:logout).once.and_raise(StandardError)
    end

    assert_equal 120, @port.value
  end

  def test_logout_must_be_called_if_login_succeeds
    setup_quote_service do
      @quote_mock.should_receive(:quote).and_raise(StandardError)
      @port.add_stock("APPL")
    end

    assert_nil @port.value
  end

end
