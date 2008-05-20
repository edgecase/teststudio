#!/usr/bin/env ruby

require 'rubygems'
require 'test/unit'
require 'rate_calculator'
require 'flexmock/test_unit'
require 'date'

######################################################################
class RateCalculatorTest < Test::Unit::TestCase

  Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, NextSunday =
    (Date.new(2007,8,19) .. Date.new(2007,8,26)).to_a

  def setup
    @service = flexmock("availability service")
    @service.should_receive(:availability).with(Date, "King").and_return(0.0)
    flexmock(AvailabilityService).should_receive(:new).and_return(@service)
    @calculator = RateCalculator.new
  end

  def test_weekday_rate_is_discounted_ten_percent
    assert_rate 90, basic_rate(Monday)
    assert_rate 90, basic_rate(Thursday)
    assert_rate 90, basic_rate(Friday)
  end

  def test_rate_is_based_on_percentage_not_absolute_value
    @calculator = RateCalculator.new(50)
    assert_rate 45, basic_rate(Monday)
  end

  def test_weekend_rate_is_discounted_twenty_percent
    assert_rate 80, basic_rate(Saturday)
    assert_rate 80, basic_rate(Sunday)
  end

  # rooms >= 10 <= 49 apply 20% discount

  def test_midrange_room_should_get_additional_twenty_precent_discount
    midrange_weekday_rate = 0.9*0.8*100
    assert_rate 10 * midrange_weekday_rate, room_nights(10, Wednesday)
    assert_rate 33 * midrange_weekday_rate, room_nights(33, Wednesday)
    assert_rate 49 * midrange_weekday_rate, room_nights(49, Wednesday)
  end

  def test_large_number_of_rooms_should_get_additional_thirty_precent_discount
    large_weekday_rate = 0.9*0.7*100
    assert_rate 50 * large_weekday_rate, room_nights(50, Wednesday)
    assert_rate 63 * large_weekday_rate, room_nights(63, Wednesday)
  end

  def test_multiple_days_are_the_sum_of_the_individual_days
    wednesday_rate = room_nights(1, Wednesday)
    thursday_rate = room_nights(1, Thursday)
    assert_rate wednesday_rate + thursday_rate, multiple_days(Wednesday, Friday)
  end

  def test_multiple_days_are_the_sum_of_the_individual_days_over_weekend
    expected_rate = room_nights(1, Wednesday) +
      room_nights(1, Thursday) + 
      room_nights(1, Friday) + 
      room_nights(1, Saturday)
    assert_rate expected_rate, multiple_days(Wednesday, NextSunday)
  end

  def test_full_rate_if_nothing_available
    @service.should_receive(:availability).once.with(Monday, "Double").
      and_return(1.0)
    
    actual_rate = @calculator.rate(Monday, Tuesday, 1, "Double")

    assert_equal 100.0, actual_rate
  end

  private

  def basic_rate(day)
    room_nights(1, day)
  end
  
  def room_nights(rooms, day)
    @calculator.rate(day, day+1, rooms, "King")
  end

  def multiple_days(check_in, check_out)
    @calculator.rate(check_in, check_out, 1, "King")
  end

  def assert_rate(expected, actual)
    assert_in_delta expected, actual, 0.01,
      "Total should be #{expected} but was #{actual}"
  end

end

