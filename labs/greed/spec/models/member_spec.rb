require 'spec_helper'

describe Member do
  it "has a valid default factory" do
    Factory(:member).should be_valid
  end

  describe "its validations" do
    before { Factory.create(:member) }

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it {
      should ensure_length_of(:name).
      is_at_least(3).
      with_short_message("needs at least 3 characters")
    }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    it { should validate_numericality_of :rank }

    it { should validate_format_of(:email).with("jim@xyz.com") }
    it { should allow_value('abc@xyz.com').for(:email) }
    it { should_not allow_value('abc@xyz').for(:email) }
    it { should_not allow_value('abc').for(:email) }
  end

  context "default values" do
    subject { Member.new }
    its(:rank) { should == 1000 }
  end

  describe "finders" do
    describe "#by_rank" do
      before do
        Factory.create(:member, :name => "Zak", :rank => 1000)
        Factory.create(:member, :name => "Adam", :rank => 1000)
        Factory.create(:member, :name => "Jim", :rank => 1200)
      end
      let(:members) { Member.by_rank }

      it "sorts by rank and name" do
        members.map(&:name).should == ['Jim', 'Adam', 'Zak']
      end
    end
  end

  describe "#matches" do
    let(:member) { Factory.create(:member) }
    let(:opponent) { Factory.create(:member) }
    before do
      Match.record_match(member, opponent)
      Match.record_match(opponent, member)
    end

    it "has the proper matches" do
      matches = member.matches
      winnings = matches.select { |m| m.winner == member }
      losings = matches.select { |m| m.loser == member }
      matches.should have(2).items
      winnings.should have(1).items
      losings.should have(1).items
    end
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
