require 'spec_helper'

describe Scorer do
  let(:scorer) { Scorer.new }

  context "#points" do
    it "scores an empty roll as zero" do
      score_of([]).should == 0
    end

    it "scores fives as fifty points" do
      score_of([5]).should == 50
    end

    it "scores ones as one hundred points" do
      score_of([1]).should == 100
    end

    it "scores triples as worth 100 times the face value" do
      score_of([2, 2, 2]).should == 200
      score_of([3, 3, 3]).should == 300
      score_of([4, 4, 4]).should == 400
      score_of([5, 5, 5]).should == 500
      score_of([6, 6, 6]).should == 600
    end

    it "scores triples of ones as worth 1000 points" do
      score_of([1, 1, 1]).should == 1000
    end

    it "scores mixed rolls" do
      score_of([2, 3, 4, 4, 6]).should == 0
      score_of([3, 5, 1, 3, 3]).should == 450
    end

    private

    def score_of(roll)
      scorer.score(roll)
      scorer.points
    end
  end

  context "#unused" do
    it "counts unused dice" do
      unused_in([]).should == 0
      unused_in([2,2,2,1,5]).should == 0
      unused_in([2,3,4,6]).should == 4
      unused_in([1,2]).should == 1
    end

    private

    def unused_in(roll)
      scorer.score(roll)
      scorer.unused
    end
  end
end
