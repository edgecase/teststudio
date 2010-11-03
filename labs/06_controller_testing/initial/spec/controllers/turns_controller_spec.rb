require 'spec_helper'

describe TurnsController do

  let(:game) { make_findable(:game) }

  describe "GET start_turn" do
    let(:game) { make_findable(:game_between_human_and_computer) }
    let(:human_player) { game.players.detect { |p| p.play_style != :automatic } }
    let(:computer_player) { game.players.detect { |p| p.play_style == :automatic } }

    context "with an interactive player" do
      before do
        game.current_player = computer_player
        flexmock(human_player).should_receive(:start_turn).once
        flexmock(human_player).should_receive(:save!).once

        get :start_turn, :game_id => game.id
      end

      it "switches to the human player" do
        game.current_player.should == human_player
      end

      it "redirects to the interactive controller" do
        response.should redirect_to(interactive_start_path(game.id))
      end
    end

    context "with a non-interactive player" do
      before do
        game.current_player = human_player
        get :start_turn, :game_id => game.id
      end

      it "switches to the computer player" do
        game.current_player.should == computer_player
      end

      it "redirects to the non-interactive controller" do
        response.should redirect_to(non_interactive_start_path(game.id))
      end
    end

    context "with a winner" do
      before do
        game.current_player = game.players.first
        game.players[0].score = 3000
        game.players[1].score = 2000

        get :start_turn, :game_id => game.id
      end

      it "the first player is still current" do
        game.current_player.should == game.players.first
      end

      it "sets the winner name" do
        @controller.winner_name.should == game.current_player.name
      end

      it "redirects to the game_over screen" do
        response.should render_template("game_over")
      end
    end
  end
end
