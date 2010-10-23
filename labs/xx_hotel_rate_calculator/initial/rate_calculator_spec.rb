#!/usr/bin/env ruby

require 'rate_calculator'

######################################################################
describe RateCalculator do
  it "calculates the rate" do
    checkin = Date.parse("Oct 18, 2010")
    RateCalculator.new.rate(checkin, checkin+1, 1).should == 90
  end

  # Add more tests
end
