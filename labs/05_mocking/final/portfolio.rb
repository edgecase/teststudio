#!/usr/bin/ruby -wKU

require 'quote_service'

class Portfolio
  def initialize
    @quote_service = QuoteService.new
    @stocks = []
  end

  def add_stock(name)
    @stocks << name
  end

  def value
    sum_values if login?
  end

  private

  def login?
    begin
      @quote_service.login("USER", "PASSWORD")
      true
    rescue StandardError => ex
      false
    end
  end

  def sum_values
    @stocks.inject(0) { |sum, name| sum + @quote_service.quote(name) }
  rescue StandardError => ex
    nil
  ensure
    @quote_service.logout rescue nil
  end
    
end
