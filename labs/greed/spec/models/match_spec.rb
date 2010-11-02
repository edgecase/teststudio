require 'spec_helper'

describe Match do
  it "has a valid factory" do
    Factory(:match).should be_valid
  end

  describe "its validations" do
    it { should validate_presence_of :winner }
    it { should validate_presence_of :loser }
    it { should validate_presence_of :played_on }

    context "with the same winner as loser" do
      let(:member) { Factory.create(:member) }
      let(:match) { Factory(:match, :winner => member, :loser => member) }
      it "is invalid" do
        match.should_not be_valid
        match.errors[:base].should_not be nil
      end
    end
  end

  describe "#record_match" do
    let(:winner) { Factory(:member, :name => "Winner", :rank => 1100) }
    let(:loser)  { Factory(:member, :name => "Loser",  :rank => 900) }

    before do
      @match = Match.record_match(winner, loser)
    end
    subject { @match }

    its(:winner) { should be winner }
    its(:winner_old_rank) { should == 1100 }
    its(:winner_new_rank) { should > 1100 }
    its(:loser) { should be loser }
    its(:loser_old_rank) { should == 900 }
    its(:loser_new_rank) { should be < 900 }
    its(:played_on) { should == Date.today }
    specify { winner.rank.should > 1100 }
    specify { loser.rank.should < 900 }
  end
end
