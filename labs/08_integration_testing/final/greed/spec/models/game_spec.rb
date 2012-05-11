require 'spec_helper'

describe Game do
  Given(:winner) { Member.new(name: "Jim", rank: 1000) }
  Given(:loser)  { Member.new(name: "Bob", rank: 1000) }
  Given(:game) { Game.new(winner: winner, loser: loser) }

  describe "validations" do
    context "with good data" do
      Then { game.should be_valid }
    end
    context "without a winner" do
      Given(:winner) { nil }
      Then { game.should have(1).error_on(:winner) }
    end
    context "without a loser" do
      Given(:loser) { nil }
      Then { game.should have(1).error_on(:loser) }
    end
    context "with both winner and loser the same" do
      Given(:loser) { winner }
      Then { game.should have(1).error_on(:base) }
    end
  end

  describe "relations" do
    Given(:winner_id) { "100" }
    Given(:loser_id)  { "101" }
    Given { flexmock(Member).should_receive(:find_by_id).with("100").and_return(winner) }
    Given { flexmock(Member).should_receive(:find_by_id).with("101").and_return(loser) }
    Given { flexmock(Member).should_receive(:find_by_id).with(nil).and_return(nil) }
    Given { flexmock(Member).should_receive(:find_by_id).with("").and_return(nil) }

    When(:game) { Game.new(winner_id: winner_id, loser_id: loser_id) }

    context "with valid IDs" do
      Then { game.winner.should == winner }
      Then { game.loser.should == loser }
    end

    context "with nil IDs" do
      Given(:winner_id) { nil }
      Given(:loser_id)  { nil }
      Then { game.winner.should be_nil }
      Then { game.loser.should be_nil }
    end

    context "with empty IDs" do
      Given(:winner_id) { "" }
      Given(:loser_id)  { "" }
      Then { game.winner.should be_nil }
      Then { game.loser.should be_nil }
    end
  end

  context "when adjusting game rank" do
    When { game.update_ranks }

    Then { winner.rank.should == 1016 }
    Then { loser.rank.should == 984 }
  end
end
