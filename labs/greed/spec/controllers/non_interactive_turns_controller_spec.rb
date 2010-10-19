require 'spec_helper'

describe NonInteractiveTurnsController do

  let!(:game) { make_findable(:game) }
  let!(:player) {
    Factory.build(:computer_player).tap { |p|
      game.players << p
      game.current_player = p
    }
  }

  describe "GET start" do
    before do
      flexmock(player).should_receive(:take_turn).once
      flexmock(player).should_receive(:save_roll!).once
      get :start, :game_id => game.id
    end
    it "redirects to the non_interactive results" do
      response.should redirect_to non_interactive_results_path(game.id)
    end
  end

  describe "GET results" do
    context "when there is no winner" do
      before do
        flexmock(player, :score => 100)
        get :results, :game_id => game.id
      end

      it "renders the results template" do
        response.should render_template("results")
      end

      it "sets the most recent turn" do
        @controller.most_recent_turn.should == [player.turns.last]
      end
    end

    context "when there is a winner" do
      before do
        flexmock(player, :score => 3000)
        get :results, :game_id => game.id
      end

      it "redirects to" do
        response.should redirect_to game_over_path(game)
      end
    end
  end

end
