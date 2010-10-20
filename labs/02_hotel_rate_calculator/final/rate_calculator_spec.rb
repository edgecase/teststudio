#!/usr/bin/env ruby

require 'date'
require 'rate_calculator'

######################################################################
describe RateCalculator do
  MONDAY = Date.parse("Oct 18, 2010")
  FRIDAY = Date.parse("Oct 22, 2010")
  SATURDAY = Date.parse("Oct 23, 2010")

  let(:checkin) { MONDAY }
  let(:checkout) { checkin + 1 }
  let(:rooms) { 1 }
  let(:base_rate) { 100 }
  let(:ratecalc) { RateCalculator.new(base_rate) }
  subject { ratecalc.rate(checkin, checkout, rooms) }

  context "for a single date and single room" do
    it { should == 90 }
  end

  context "with a interesting base rate" do
    let(:base_rate) { 200 }

    context "one week day" do
      it { should == 180 }
    end

    context "over several days" do
      let(:checkout) { checkin + 3 }
      it { should == 3 * 180 }
    end

    context "one weekend day" do
      let(:checkin) { SATURDAY }
      it { should == 160 }
    end

    context "two weekend das" do
      let(:checkin) { SATURDAY }
      let(:checkout) { checkin + 2 }
      it { should == 2 * 160 }
    end

    context "across both weekdays and weekends" do
      let(:checkin) { FRIDAY }
      let(:checkout) { checkin + 5 }
      it { should == 3*180 + 2*160 }
    end
  end

  context "with multiple rooms" do
    let(:rooms) { 3 }
    it { should == 3 * 90 }
  end

end
