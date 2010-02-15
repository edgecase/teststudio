#!/usr/bin/ruby -wKU

require 'quote_service'

class Portfolio
  def initialize
    @quote_service = QuoteService.new
  end

  def add_stock(name)
    # implement this
  end

  def value
    # implement this
  end
end
