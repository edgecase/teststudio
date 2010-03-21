require 'test_helper'

class InteractiveTurnsControllerTest < ActionController::TestCase
  def setup
    super
    @game = Factory.build :two_player_game
    flexmock(@game, :id => 12345)
    should_find(Game, @game).once
    @human = human_player_in(@game)
    @computer = computer_player_in(@game)
    @game.current_player = @human
    @params = { :id => @game.id.to_s }
  end
  
  # ==================================================================

  def do_roll
    get :roll, @params
  end

  context 'The roll action' do
    setup do
      flexmock(@human).should_receive(:save!).once
    end
    context 'when the roll was a bust' do
      setup do
        flexmock(@human).should_receive(:roll_dice).once.and_return(:bust)
      end
      should 'redirect to the bust action' do
        do_roll
        assert_redirected_to bust_interactive_turn_path(@game)
      end
    end
    context 'when the roll was not a bust' do
      setup do
        flexmock(@human).should_receive(:roll_dice).once.and_return(:ok)
      end
      should 'redirect to the bust action' do
        do_roll
        assert_redirected_to decide_interactive_turn_path(@game)
      end
    end
  end
  
  # ==================================================================

  def do_bust
    get :bust, @params
  end

  context 'The bust action' do
    should 'assign the game for the view' do
      do_bust
      assert_equal @game, assigns(:game)      
    end
  end
  
  # ==================================================================

  def do_decide
    get :decide, @params
  end

  context 'The decide action' do
    should 'assigns game for view' do
      do_decide
      assert_equal @game, assigns(:game)      
    end
    should 'assigns rolls for view' do
      do_decide
      assert_equal @game.current_player.turns.last.rolls, assigns(:rolls)
    end
  end

  # ==================================================================

  def do_holds
    get :hold, @params
  end

  context 'The holds action' do
    setup do
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end

    should 'hold the player' do
      flexmock(@human).should_receive(:holds).once
      flexmock(@human).should_receive(:save!).once
      do_holds
    end

    context 'when no winner' do
      should 'redirect to the start turn' do
        do_holds
        assert_redirected_to start_turn_path(@game)
      end
    end
    context 'when winner' do
      setup do
        @game.current_player.score = 3000
      end
      should 'redirect to the game over url' do
        do_holds
        assert_redirected_to game_over_path(@game)
      end
    end
  end
end
