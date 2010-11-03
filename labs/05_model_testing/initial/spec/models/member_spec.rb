require 'spec_helper'

describe Member do
  it "has a valid default factory" do
    Factory(:member).should be_valid
  end

  describe "its validations" do
    # Add specs
  end

  context "newly created" do
    it "has a rank of 1000"
  end

  describe "finders" do
    describe "#by_rank" do
      it "sorts by rank and name"
    end
  end

  describe "#matches" do
    it "has the proper matches"
  end

  describe "rank management" do
    context "against an equal opponent" do
      context "wins" do
      end
      context "loses" do
      end
    end

    context "against a stronger opponent" do
      context "wins" do
      end
      context "loses" do
      end
    end

    context "against a weaker opponent" do
      context "wins" do
      end
      context "loses" do
      end
    end
  end
end
