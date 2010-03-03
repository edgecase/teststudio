require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================
  
  def do_index
    get :index, @params
  end
  
  context 'The choose_players action' do
    setup do
      @game = Factory(:empty_game)
      flexmock(@game, :id => 123)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :game_id => @game.id }
    end
    
    should 'assign a game' do
      do_index
      assert_equal @game, assigns(:game)
    end

    should 'assign a list of available players' do
      do_index
      assert_equal AutoPlayer.players, assigns(:players)
    end
  end
  
  # ==================================================================

  def do_create
    post :create, @params
  end
  
  context 'The create action' do
    setup do
      @game = Factory(:empty_game)
      @game.players << Factory.build(:human_player, :position => 2)
      should_find(Game, @game).once
      @params = { :game_id => @game.id.to_s }
    end
    
    should 'assign the game' do
      do_create
      assert_equal @game, assigns(:game)
    end
    
    context 'when the strategy name is blank' do
      setup do
        @params.merge!( :player => "" )
      end

      should 'give a flash error' do
        do_create
        assert_match(/please select/i, flash[:error])
      end

      should 'redirect to choosing a player' do
        do_create
        assert_response :redirect
        assert_redirected_to game_players_path(@game)
      end
    end

    context 'when the strategy name is given' do
      setup do
        @params.merge!( :player => "randy" )
      end
      
      should 'add the named strategy to the computer player' do
        do_create
        assert_equal "randy", assigns(:game).players.last.strategy
      end

      should 'save the game' do
        flexmock(@game).should_receive(:save).once
        do_create
      end
      
      should 'start the computers turn' do
        do_create
        assert_redirected_to start_turn_path(@game)
      end
    end
  end
end
