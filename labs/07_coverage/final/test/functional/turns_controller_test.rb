require 'test_helper'

class TurnsControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================

  def do_start_turn
    get :start_turn, @params
  end
  
  context 'The start_turn action' do
    setup do
      @game = Factory(:two_player_game)
      @human = human_player_in(@game)
      @computer = computer_player_in(@game)
      should_find(Game, @game).once
      @params = { :game => @game.id.to_s }
    end
    
    context 'with a human player' do
      setup do
        @game.current_player = @computer
        flexmock(@human).should_receive(:start_turn).once
      end
      should 'redirect to the interactive controller' do
        do_start_turn
        assert_redirected_to roll_interactive_turn_path(@game)
      end
    end
    
    context 'with a computer player' do
      setup do
        @game.current_player = @human
        flexmock(@computer).should_receive(:start_turn).never
      end
      should 'redirect to the non-interactive controller' do
        do_start_turn
        assert_redirected_to start_non_interactive_turn_path(@game)
      end
    end
  end

  # ==================================================================

  def do_game_over
    get :game_over, @params
  end
  
  context 'The game_over action' do
    setup do
      @game = Factory.build(:two_player_game)
      flexmock(@game, :id => 12345)
      should_find(Game, @game)
      @computer = computer_player_in(@game)
      @game.current_player = @computer
      @params = { :game => @game.id.to_s }
      do_game_over
    end
    should 'assign the game for the view' do
      assert_equal @game, assigns(:game)
    end
    should 'assign the winner for the view' do
      assert_equal @computer.name, assigns(:winner)
    end
  end
end
