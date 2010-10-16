require 'spec_helper'

describe Turn do
  it "has a valid factory" do
    Factory.build(:turn).should be_valid
  end

  let(:player) { Factory.build(:player) }
  let(:turn) { Factory.build(:turn, :player => player) }

  subject { turn }

  its(:player) { should == player }

  context "with several rolls" do
    let(:r1) { Factory.build(:roll, :accumulated_score => 100, :position => 1) }
    let(:r2) { Factory.build(:roll, :accumulated_score => 250, :position => 2) }
    before { subject.rolls = [r1, r2] }

    its(:rolls) { should == [r1, r2] }
    its(:score) { should == r2.accumulated_score }
  end

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

  describe "#pending?" do
    context "with no rolls" do
      let(:turn) { Factory.build(:turn) }
      its(:pending?) { should be_false }
    end

    context "when the last action of the last roll is unknown" do
      let(:turn) { turn_with_several_rolls(nil) }
      its(:pending?) { should be_true }
    end

    context "when the last action of the last roll is known" do
      let(:turn) { turn_with_several_rolls(:hold) }
      its(:pending?) { should be_false }
    end

    private

    def turn_with_several_rolls(last_action=nil)
      turn = Factory.build(:turn)
      turn.rolls << Factory.build(:roll, :accumulated_score => 100)
      turn.rolls << Factory.build(:roll, :accumulated_score => 250, :action => last_action)
      turn
    end
  end
end
