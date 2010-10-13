require 'spec_helper'

describe ComputerPlayer do
  it "has a valid factory" do
    Factory.build(:computer_player).should be_valid
  end

  let(:player) { Factory.build(:computer_player) }
  subject { player }

  its(:play_style) { should == :automatic }
  its(:score) { should == 0 }

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
    let(:game) {
      Factory.build(:game,
        :players => [Factory.build(:computer_player)])
    }
    let(:player) { game.players.first }
    let(:turn) { player.take_turn }

    context "where the player goes bust on the first roll" do
      before do
        inject_roll(5, [4,2,2,3,3])
        player_rolls.never
      end

      it "has a zero point bust" do
        turn.rolls[0].points.should == 0
        turn.rolls[0].unused.should == 5
        turn.rolls[0].action.should be :bust

        turn.score.should == 0
      end
    end

    context "where a player holds on first roll" do
      before do
        inject_roll(5, [1,2,2,3,3])
        player_rolls.once.and_return(false)
      end

      it "has some points" do
        turn.score.should == 100
        turn.rolls[0].points.should == 100
        turn.rolls[0].unused.should == 4
        turn.rolls[0].action.should == :hold

        turn.score.should == 100
      end
    end

    context 'where the player rolls again, then goes bust' do
      before do
        inject_roll(5, [1,1,1,1,1])
        player_rolls.once.and_return(true)
        inject_roll(5, [2,2,3,3,4])
      end

      it "has the proper accumulated points" do
        turn.rolls[0].points.should == 1200
        turn.rolls[0].action.should == :roll

        turn.rolls[1].points.should == 0
        turn.rolls[1].action.should == :bust

        turn.score.should == 0
      end
    end

    context 'where the player rolls again, then holds' do
      before do
        inject_roll(5, [1,2,2,3,3])
        player_rolls.once.and_return(true)
        inject_roll(4, [5,2,3,3])
        player_rolls.once.and_return(false)
      end

      it "has the proper accumulated points" do
        turn.rolls[0].points.should == 100
        turn.rolls[0].action.should == :roll
        turn.rolls[0].accumulated_score.should == 100

        turn.rolls[1].points.should == 50
        turn.rolls[1].accumulated_score.should == 150
        turn.rolls[1].action.should == :hold

        turn.score.should == 150
      end
    end

    context 'where the player rolls all scoring, then rolls and holds' do
      before do
        inject_roll(5, [1,1,1,5,5])
        player_rolls.once.and_return(true)
        inject_roll(5, [1,2,3,3])
        player_rolls.once.and_return(false)
      end

      it "has the proper accumulated points" do
        turn.rolls[0].points.should == 1100
        turn.rolls[0].action.should == :roll
        turn.rolls[0].accumulated_score.should == 1100

        turn.rolls[1].points.should == 100
        turn.rolls[1].accumulated_score.should == 1200
        turn.rolls[1].action.should == :hold

        turn.score.should == 1200
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
