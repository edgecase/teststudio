require 'spec_helper'

describe InteractiveTurnsController do
  let(:game) {
    g = make_findable(:game)
    g.players << Factory.build(:human_player)
    g.current_player = g.players.first
    g.current_player.start_turn
    g
  }
  let(:current_player) { game.current_player }

  describe "GET roll" do
    before do
      flexmock(current_player).should_receive(:roll_dice).once.by_default
      flexmock(current_player).should_receive(:save_roll!).once
      flexmock(current_player).should_receive(:undecided?).
        and_return(false).by_default
      flexmock(current_player).should_receive(:decides_to_roll_again).
        never.by_default
    end

    context "with a undecided on the current roll" do
      before do
        flexmock(current_player, :undecided? => true)
        flexmock(current_player).should_receive(:decides_to_roll_again).once
        get :roll, :game_id => game.id
      end
      it "marks the undecided roll with :roll" do
        # spec'ed in the mocks
      end
    end

    context "with a good score" do
      before do
        flexmock(current_player).should_receive(:roll_dice).
            and_return(:ok).once
        get :roll, :game_id => game.id
      end
      it { response.should redirect_to(interactive_decide_path(game.id)) }
    end

    context "with a bust score" do
      before do
        flexmock(current_player).should_receive(:roll_dice).
            and_return(:bust).once
        get :roll, :game_id => game.id
      end
      it { response.should redirect_to(interactive_bust_path(game.id)) }
    end
  end

  describe "GET bust" do
    before do
      current_player.roll_dice
      flexmock(current_player).should_receive(:goes_bust).once
      flexmock(current_player).
        should_receive("turns.last.rolls").
        and_return(:rolls_result)
      get :bust, :game_id => game.id
    end

    it "sets assumptions" do
      @controller.game.should be game
      @controller.last_rolls.should be :rolls_result
    end

    it "renders the bust template" do
      response.should render_template("bust")
    end
  end

  describe "GET decide" do
    before do
      flexmock(current_player).
        should_receive("turns.last.rolls").
        and_return(:rolls_result)
      get :decide, :game_id => game.id
    end

    it "sets assumptions" do
      @controller.game.should be game
      @controller.last_rolls.should be :rolls_result
    end

    it "renders the bust template" do
      response.should render_template("decide")
    end
  end

  describe "GET hold" do
    before do
      current_player.roll_dice
      flexmock(current_player).should_receive(:decides_to_hold).once
      flexmock(current_player).should_receive(:save_roll!).once.
        and_return(true)
    end


    context "with a score less that the winning score" do
      before do
        flexmock(current_player, :score => 100)
        get :hold, :game_id => game.id
      end
      it "redirects to start turn" do
        response.should redirect_to start_turn_path(game)
      end
    end

    context "with a winning score" do
      before do
        flexmock(current_player, :score => 3000)
        get :hold, :game_id => game.id
      end
      it "redirects to game over" do
        response.should redirect_to game_over_path(game)
      end
    end
  end
end
