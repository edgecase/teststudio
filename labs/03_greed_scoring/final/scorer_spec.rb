require 'scorer'
require 'rspec/given'

module RSpec
  module Matchers
    define :score_as do |points, unused|
      match do |roll|
        scorer.score(roll)
        scorer.points == points && scorer.unused == unused
      end

      failure_message_for_should do |roll|
        "#{roll} should score as #{points} and #{unused}, but was #{scorer.points} and #{scorer.unused}" +
          "\nactual=#{actual}" +
          "\nexpected=#{expected}"
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
  context "handles 5s" do
    Then { [5].should score_as(50,0) }
    Then { [5,5].should score_as(100,0) }
    Then { [5,5,2,3,2].should score_as(100,3) }
  end

  context "handles 1s" do
    Then { [1].should score_as(100,0) }
    Then { [1,1].should score_as(200, 0) }
    Then { [1,4,1].should score_as(200,1) }
  end

  context "handles triplets" do
    Then { [2,2,2].should score_as(200,0) }
    Then { [6,6,6,2,3].should score_as(600,2) }
  end

  context "handles triplets of 1 and 5" do
    Then { [1,1,1].should score_as(1000, 0) }
    Then { [5,5,5].should score_as(500, 0) }
  end

  context "handles more than 3 1s or 5s" do
    Then { [1,1,1,1,1].should score_as(1200, 0) }
    Then { [5,5,5,5,5].should score_as(600, 0) }
  end

  context "handles mixed combinations" do
    Then { [5,2,1,2,2].should score_as(350, 0) }
    Then { [1,2,3,4,5].should score_as(150, 3) }
  end
end
