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
end
