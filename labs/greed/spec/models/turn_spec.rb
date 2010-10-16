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
