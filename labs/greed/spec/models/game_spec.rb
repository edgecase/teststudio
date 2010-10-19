require 'spec_helper'

describe Game do
  let(:game) { Factory.build(:game_between_human_and_computer) }
  let(:player1) { game.players[0] }
  let(:player2) { game.players[1] }

  context "when started" do
    before do
      game.start
      game.current_player = game.next_player
    end

    it "knows the first player is the current player" do
      game.current_player.should == player1
    end
    it "calculates the next player" do
      game.next_player.should == player2
    end

    context "and setting the next player" do
      before { game.current_player = game.next_player }
      it "reports the new current player" do
        game.current_player.should == player2
      end
      it "reports the new next player" do
        game.next_player.should == player1
      end
    end
  end
end
