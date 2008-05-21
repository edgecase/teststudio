#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'firewatir'
require 'date'

class WatirTest < Test::Unit::TestCase
  def setup
    @ff = FireWatir::Firefox.new
  end

  def test_make_a_reservation
    @ff.goto("http://localhost:3000")
    @ff.link(:text, "Make a reservation").click
    @ff.text_field(:id, "reservation_name").value = "Bill"
    @ff.button(:value, "Book this room").click

    today = Date.today.to_s(:db)
    tomorrow = (Date.today+1).to_s(:db)
    assert_match(/Reservation for: Bill/, @ff.text)
    assert_match(/Checking in: *#{today}/i, @ff.text)
    assert_match(/Checking out: *#{tomorrow}/i, @ff.text)
  end
end
