require 'spec_helper'

describe Game do
  let(:player1) { Factory.build(:player) }
  let(:player2) { Factory.build(:player) }
  let(:game) { Factory.build(:game, :players => [player1, player2]) }

  context "when started" do
    before { game.start }
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
