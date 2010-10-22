require 'spec_helper'

describe Turn do
  it "has a valid factory" do
    Factory(:turn).should be_valid
  end

  let(:player) { Factory(:player) }
  let(:turn) { Factory(:turn, :player => player) }

  subject { turn }

  its(:player) { should == player }

  describe "#roll_dice" do
    context "with any roll" do
      let!(:original_roll_count) { turn.rolls.size }
      let(:roller) { roller_that_rolled(5, [1,2,3,4,5]) }
      before do
        @roll_result = turn.roll_dice(roller)
      end

      it "adds a roll" do
        turn.rolls.should have(original_roll_count+1).faces
      end
      it "should have matching faces" do
        turn.rolls.last.faces.map(&:value).should == [1,2,3,4,5]
      end
    end

    context "with a good roll" do
      let(:roller) { roller_that_rolled(5, [1,2,3,4,5]) }

      it "should be ok" do
        turn.roll_dice(roller).should == :ok
      end
    end

    context "with a bust roll" do
      let(:roller) { roller_that_rolled(5, [2,2,3,4,4]) }

      it "should be bust" do
        turn.roll_dice(roller).should == :bust
      end
    end
  end

  describe "#score" do
    context "with no rolls" do
      its(:score) { should be_zero }
    end

    context "with several rolls" do
      let(:turn) { turn_with_rolls([1,2,3,4,5], [1,3,2,3,4]) }
      its(:score) { should == 250 }
    end

    context "with several rolls ending with a bust" do
      let(:turn) { turn_with_rolls([1,2,3,4,5], [2,3,2,3,4]) }
      its(:score) { should == 0 }
    end
  end

  describe "#score_up_to" do
    context "with several rolls" do
      let(:turn) { turn_with_rolls([1,5,2,3,4], [1], [1,1,1]) }
      let(:second_roll) { turn.rolls[1] }
      it "adds score up thru the indicated roll" do
        turn.score_up_to(second_roll).should == 250
      end
    end

    context "with several rolls ending in a bust" do
      let(:turn) { turn_with_rolls([1,5,2,3,4], [1], [2]) }
      let(:third_roll) { turn.rolls[2] }
      it "adds score up thru the indicated roll" do
        turn.score_up_to(third_roll).should == 0
      end
    end
  end

  describe "#undecided?" do
    context "with no rolls" do
      let(:turn) { Factory(:turn) }
      its(:undecided?) { should be_false }
    end

    context "when the last action of the last roll is unknown" do
      let(:turn) { Factory(:turn_ending_with_unknown) }
      its(:undecided?) { should be_true }
    end

    context "when the last action of the last roll is known" do
      let(:turn) { Factory(:turn_ending_with_hold) }
      its(:undecided?) { should be_false }
    end
  end

  private

  def turn_with_rolls(*face_list)
    turn = Factory(:turn)
    face_list.each { |face_values|
      turn.rolls << Factory(:roll,
        :faces => faces(*face_values),
        :action => :roll)
    }
    scorer.score(turn.rolls.last.faces.map { |f| f.value })
    if scorer.points == 0
      turn.rolls.last.action = :bust
    else
      turn.rolls.last.action = :hold
    end
    turn
  end

  def scorer
    @scorer ||= Scorer.new
  end

  def faces(*face_values)
    face_values.map { |f| Face.new(:value => f) }
  end
end
