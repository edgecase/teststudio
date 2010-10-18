require 'spec_helper'

describe ComputerPlayer do
  let(:player) { Factory.build(:computer_player) }
  subject { player }

  it "has a valid factory" do
    player.should be_valid
  end

  it { should be_a(ComputerPlayer) }
  its(:play_style) { should == :automatic }
  its(:score) { should == 0 }

  context "assigning a strategy" do
    before { player.strategy = "ConservativeStrategy" }
    its(:logic) { should be_a(ConservativeStrategy) }
    its(:strategy) { should == "ConservativeStrategy" }
  end

  context "after loading" do
    before do
      player.strategy = "ConservativeStrategy"
      player.save
      player.reload
    end
    it "has a valid logic set according to its strategy" do
      player.logic.should be_a(ConservativeStrategy)
    end
  end

  context "with a strategy" do
    let(:strategy) { flexmock("Strategy") }
    before { player.instance_variable_set("@logic", strategy) }

    it "delegates name to strategy" do
      strategy.should_receive(:name).once
      player.name
    end

    it "delegates description to strategy" do
      strategy.should_receive(:description).once
      player.description
    end

    it "delegates roll_again? to strategy" do
      strategy.should_receive(:roll_again?).once
      player.roll_again?
    end
  end

  describe "playing the game" do
    let(:turn) { player.last_turn }
    before do
      player.score = 100
    end

    context "where the player goes bust on the first roll" do
      before do
        inject_roll(5, [4,2,2,3,3])
        player_rolls.never
        player.take_turn
      end

      it "has a zero point bust" do
        turn
        turn.rolls[0].points.should == 0
        turn.rolls[0].unused.should == 5
        turn.rolls[0].action.should be :bust

        turn.score.should == 0
      end

      it "doesn't effect the player score" do
        player.score.should == 100
      end
    end

    context "where a player holds on first roll" do
      before do
        inject_roll(5, [1,2,2,3,3])
        player_rolls.once.and_return(false)
        player.take_turn
      end

      it "has some points" do
        turn.score.should == 100
        turn.rolls[0].points.should == 100
        turn.rolls[0].unused.should == 4
        turn.rolls[0].action.should == :hold

        turn.score.should == 100
      end

      it "adds the score to the player total" do
        player.score.should == 100 + 100
      end
    end

    context 'where the player rolls again, then goes bust' do
      before do
        inject_roll(5, [1,1,1,1,1])
        player_rolls.once.and_return(true)
        inject_roll(5, [2,2,3,3,4])
        player.take_turn
      end

      it "has the proper points" do
        turn.rolls[0].points.should == 1200
        turn.rolls[0].action.should == :roll

        turn.rolls[1].points.should == 0
        turn.rolls[1].action.should == :bust

        turn.score.should == 0
      end

      it "busting does not change the total score" do
        player.score.should == 100
      end
    end

    context 'where the player rolls again, then holds' do
      before do
        inject_roll(5, [1,2,2,3,3])
        player_rolls.once.and_return(true)
        inject_roll(4, [5,2,3,3])
        player_rolls.once.and_return(false)
        player.take_turn
      end

      it "has the proper points" do
        turn.rolls[0].points.should == 100
        turn.rolls[0].action.should == :roll

        turn.rolls[1].points.should == 50
        turn.rolls[1].action.should == :hold

        turn.score.should == 150
      end

      it "adds the turn score to the player total" do
        player.score.should == 100 + 150
      end
    end

    context 'where the player rolls all scoring, then rolls and holds' do
      before do
        inject_roll(5, [1,1,1,5,5])
        player_rolls.once.and_return(true)
        inject_roll(5, [1,2,3,3])
        player_rolls.once.and_return(false)
        player.take_turn
      end

      it "has the proper points" do
        turn.rolls[0].points.should == 1100
        turn.rolls[0].action.should == :roll

        turn.rolls[1].points.should == 100
        turn.rolls[1].action.should == :hold

        turn.score.should == 1200
      end

      it "adds the turn score to the player total" do
        player.score.should == 100 + 1200
      end
    end

    private

    def inject_roll(dice_count, faces)
      flexmock(player.roller).should_receive(:random_faces).
        with(dice_count).
        once.and_return(faces)
    end

    def player_rolls
      flexmock(player).should_receive(:roll_again?)
    end
  end
end
