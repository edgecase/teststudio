require 'spec_helper'

describe Member do
  it "has a valid default factory" do
    Factory(:member).should be_valid
  end

  describe "its validations" do
    it { should validate_presence_of :name }
    it {
      should ensure_length_of(:name).
      is_at_least(3).
      with_short_message("needs at least 3 characters")
    }

    it { should validate_presence_of :email }
    it { should validate_presence_of :email }

    it { should validate_presence_of :rank }
    it { should validate_numericality_of :rank }

    it { should allow_value('abc@xyz.com').for(:email) }
    it { should_not allow_value('abc@xyz').for(:email) }
    it { should_not allow_value('abc').for(:email) }
  end

  context "default values" do
    subject { Member.new }
    its(:rank) { should == 1000 }
  end

  describe "rank management" do
    let(:member) { Factory(:member) }
    let!(:original_rank) { member.rank }

    subject { member }

    context "against an equal opponent" do
      let(:opponent_rank) { member.rank }

      context "wins" do
        before { member.wins_against(opponent_rank) }
        its(:rank) { should == original_rank + 16 }
      end
      context "draws" do
        before { member.draws_against(opponent_rank) }
        its(:rank) { should == original_rank }
      end
      context "loses" do
        before { member.loses_against(opponent_rank) }
        its(:rank) { should == original_rank - 16}
      end
    end

    context "against a stronger opponent" do
      let(:opponent_rank) { member.rank + 100 }
      context "wins" do
        before { member.wins_against(opponent_rank) }
        its(:rank) { should == original_rank + 20 }
      end
      context "draws" do
        before { member.draws_against(opponent_rank) }
        its(:rank) { should == original_rank + 4 }
      end
      context "loses" do
        before { member.loses_against(opponent_rank) }
        its(:rank) { should == original_rank - 12}
      end
    end

    context "against a weaker opponent" do
      let(:opponent_rank) { member.rank - 100 }
      context "wins" do
        before { member.wins_against(opponent_rank) }
        its(:rank) { should == original_rank + 12 }
      end
      context "draws" do
        before { member.draws_against(opponent_rank) }
        its(:rank) { should == original_rank - 4 }
      end
      context "loses" do
        before { member.loses_against(opponent_rank) }
        its(:rank) { should == original_rank - 20}
      end
    end
  end
end
