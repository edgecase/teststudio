require 'spec_helper'

describe TurnsController do

  let(:game) { make_findable(:game) }

  describe "GET start_turn" do
    context "with an interactive player" do
      before do
        game.players << Factory.build(:human_player)
        game.current_player = game.players.first
        get :start_turn, :game_id => game.id
      end
      it "redirects to the interactive controller" do
        response.should redirect_to(interactive_start_path(game.id))
      end
    end

    context "with a non-interactive player" do
      before do
        game.players << Factory.build(:computer_player)
        game.current_player = game.players.first
        get :start_turn, :game_id => game.id
      end
      it "redirects to the non-interactive controller" do
        response.should redirect_to(non_interactive_start_path(game.id))
      end
    end
  end

  describe "GET game_over" do
    before do
      game.players << Factory.build(:human_player)
      game.current_player = game.players.first
      get :game_over, :game_id => game.id
    end
    it "sets the winner" do
      assigns[:winner].should == game.current_player
    end
    it { response.should render_template "game_over" }
  end

end
