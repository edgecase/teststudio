require 'spec_helper'

describe Turn do
  it "has a valid factory" do
    Factory.build(:turn).should be_valid
  end

  let(:player) { Factory.build(:player) }
  let(:turn) { Factory.build(:turn, :player => player) }

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
      let(:turn) { turn_with_several_rolls }
      its(:score) { should == 250 }
    end

    context "with several rolls ending with a bust" do
      let(:turn) { turn_with_a_bust }
      its(:score) { should == 0 }
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
  end

  private

  def turn_with_several_rolls(last_action=:hold)
    turn = Factory.build(:turn)
    turn.rolls << Factory.build(:roll, :faces => faces(1,2,3,2,3), :action => :roll)
    turn.rolls << Factory.build(:roll, :faces => faces(1,5,3,2,3), :action => last_action)
    turn
  end

  def turn_with_a_bust(last_action=:hold)
    turn = Factory.build(:turn)
    turn.rolls << Factory.build(:roll, :faces => faces(1,2,3,2,3), :action => :roll)
    turn.rolls << Factory.build(:roll, :faces => faces(2,3,4,3,4), :action => :bust)
    turn
  end

  def faces(*face_values)
    face_values.map { |f| Face.new(:value => f) }
  end
end
