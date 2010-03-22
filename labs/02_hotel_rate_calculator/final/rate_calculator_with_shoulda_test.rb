#!/usr/bin/env ruby

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rate_calculator'
require 'date'

######################################################################
class RateCalculatorTest < Test::Unit::TestCase

  Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, NextSunday =
    (Date.new(2007,8,19) .. Date.new(2007,8,26)).to_a
  
  context 'A rate calculator' do
    setup do
      @rack_rate = 100
    end
    
    context 'with a rack rate of 50' do
      setup { @rack_rate = 50 }

      context 'on a weekday' do
        setup { percent_off(10) }
        should 'be discounted by 10 percent' do
          assert_rate @discount, calculated_rate(Monday)
        end
      end
    end
    
    context 'with a rack rate of 100' do
      setup { @rack_rate = 100 }      

      context 'on a weekday' do
        setup { @discount = 0.90 * @rack_rate }
        should 'be discounted by 10 percent' do
          assert_rate @discount, calculated_rate(Monday)
          assert_rate @discount, calculated_rate(Thursday)
          assert_rate @discount, calculated_rate(Friday)
        end

        context 'with 10 or more rooms' do
          setup { @discount = 0.80 * @discount }
          should 'get an addition 20% off' do
            assert_equal 10 * @discount, calculated_rate(Wednesday, 10)
            assert_equal 33 * @discount, calculated_rate(Wednesday, 33)
            assert_equal 49 * @discount, calculated_rate(Wednesday, 49)
          end
        end

        context 'with 50 or more rooms' do
          setup { @discount = 0.70 * @discount }
          should 'get an additional 30% off' do
            assert_rate 50 * @discount, calculated_rate(Wednesday, 50)
            assert_rate 63 * @discount, calculated_rate(Wednesday, 63)
          end
        end
      end
      
      context 'on a weekend' do
        setup { @discount = 0.80 * @rack_rate }
        should 'be discounted 20 percent' do
          assert_rate @discount, calculated_rate(Saturday)
          assert_rate @discount, calculated_rate(Sunday)
        end
      end

      context 'across multiple weekdays' do
        setup do
          @expected =
            calculated_rate(Wednesday) +
            calculated_rate(Thursday)
        end
        should 'be the sum of the individual days' do
          assert_rate @expected, calculated_rate(Thursday, 1, 2)
        end
      end

      context 'across multiple days spanning a weekend' do
        setup do
          @expected =
            calculated_rate(Wednesday) +
            calculated_rate(Thursday) +
            calculated_rate(Friday) +
            calculated_rate(Saturday)
        end
        should 'be the sum of the individual days' do
          assert_rate @expected, calculated_rate(Wednesday, 1, 4)
        end
      end

    end
  end

  private

  def calculated_rate(day, rooms=1, days=1)
    @calculator = RateCalculator.new(@rack_rate)
    @calculator.rate(day, day+days, rooms)
  end

  def percent_off(percent)
    @discount = (1 - (percent / 100.0)) * @rack_rate
  end
  
  def assert_rate(expected, actual)
    assert_in_delta expected, actual, 0.01,
      "Total should be #{expected} but was #{actual}"
  end
end

