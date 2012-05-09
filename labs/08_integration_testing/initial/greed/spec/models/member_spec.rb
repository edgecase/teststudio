require 'spec_helper'

describe Member do
  Given(:default_attrs) { { name: "Jim", email: "jim@xyz.com", rank: 1000 } }
  Given(:attrs) { default_attrs }
  Given(:member) { Member.new(attrs) }

  describe "validations" do
    context "with good attributes" do
      Then { member.should be_valid }
    end

    context "without a name" do
      Given(:attrs) { default_attrs.merge(name: nil) }
      Then { member.should be_invalid_on(:name, /blank/) }
    end

    context "with a short name" do
      Given(:attrs) { default_attrs.merge(name: "Bo") }
      Then { member.should be_invalid_on(:name, 'short') }
    end

    context "without a email" do
      Given(:attrs) { default_attrs.merge(email: nil) }
      Then { member.should be_invalid_on(:email, /blank/) }
    end

    context "with an ill-formed email" do
      Given(:attrs) { default_attrs.merge(email: "bademail") }
      Then { member.should be_invalid_on(:email, 'well-formed email') }
    end

    context "without a rank" do
      Given(:attrs) { default_attrs.merge(rank: nil) }
      Then { member.should be_invalid_on(:rank, /blank/) }
    end

    context "without a non-numeric rank" do
      Given(:attrs) { default_attrs.merge(rank: "X") }
      Then { member.should be_invalid_on(:rank, "number") }
    end
  end

  describe "rank changes" do
    def member_at_rank(rank_value)
      Member.new(default_attrs.merge(rank: rank_value))
    end

    Given(:me) { member_at_rank(1000) }

    context "against an opponent of equal rank" do
      Given(:opponent) { member_at_rank(1000) }

      context "when I win" do
        When { me.wins_against(opponent.rank) }
        Then { me.rank.should == 1016 }
      end

      context "when I lose" do
        When { me.loses_against(opponent.rank) }
        Then { me.rank.should == 984 }
      end
    end

    context "against a stronger opponent" do
      Given(:opponent) { member_at_rank(1100) }

      context "when I win" do
        When { me.wins_against(opponent.rank) }
        Then { me.rank.should == 1020 }
      end

      context "when I lose" do
        When { me.loses_against(opponent.rank) }
        Then { me.rank.should == 988 }
      end
    end

    context "against a weaker opponent" do
      Given(:opponent) { member_at_rank(900) }

      context "when I win" do
        When { me.wins_against(opponent.rank) }
        Then { me.rank.should == 1012 }
      end

      context "when I lose" do
        When { me.loses_against(opponent.rank) }
        Then { me.rank.should == 980 }
      end
    end
  end

  describe ".by_rank" do
    Given!(:member2) { Member.create(name: "Bob", email: "bob@somewhere.com", rank: 900) }
    Given!(:member1) { Member.create(name: "Jim", email: "jim@somewhere.com", rank: 1000) }

    When(:members) { Member.by_rank }

    Then { members.should == [member1, member2] }
  end

  describe ".by_name" do
    Given!(:member2) { Member.create(name: "Bob", email: "bob@somewhere.com", rank: 900) }
    Given!(:member1) { Member.create(name: "Adam", email: "adam@somewhere.com", rank: 1000) }

    When(:members) { Member.by_name }

    Then { members.should == [member1, member2] }
  end
end
