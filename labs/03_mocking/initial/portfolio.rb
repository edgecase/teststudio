#!/usr/bin/ruby -wKU

require 'quote_service'

class Portfolio
  def initialize
    @quote_service = QuoteService.new
    @names = []
  end

  def add_stock(name)
    @names << name
  end

  def value
    result = nil
    @quote_service.login("user", "pw")
    result = @names.inject(0) { |sum, stock|
      sum + @quote_service.quote(stock)
    }
    @quote_service.logout
    result
  rescue StandardError
    result
  end
end
