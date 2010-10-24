require 'scorer'

module RSpec
  module Matchers
    define :score_as do |points, unused|
      match do |roll|
        scorer.score(roll)
        scorer.points == points && scorer.unused == unused
      end

      failure_message_for_should do |roll|
        "#{roll} should score as #{points} and #{unused}, but was #{scorer.points} and #{scorer.unused}"
      end

      failure_message_for_should_not do |roll|
        "#{roll} should not score as #{points} and #{unused}"
      end

      def scorer
        @scorer ||= Scorer.new
      end
    end
  end
end

describe Scorer do
  it "handles 5s" do
    [5].should score_as(50,0)
    [5,5].should score_as(100,0)
    [5,5,2,3,2].should score_as(100,3)
  end

  it "handles 1s" do
    [1].should score_as(100,0)
    [1,1].should score_as(200, 0)
    [1,4,1].should score_as(200,1)
  end

  it "handles triplets" do
    [2,2,2].should score_as(200,0)
    [6,6,6,2,3].should score_as(600,2)
  end

  it "handles triplets of 1 and 5" do
    [1,1,1].should score_as(1000, 0)
    [5,5,5].should score_as(500, 0)
  end

  it "handles more than 3 1s or 5s" do
    [1,1,1,1,1].should score_as(1200, 0)
    [5,5,5,5,5].should score_as(600, 0)
  end

  it "handles mixed combinations" do
    [5,2,1,2,2].should score_as(350, 0)
    [1,2,3,4,5].should score_as(150, 3)
  end
end
