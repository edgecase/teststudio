require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================

  def do_new
    get :new, @params
  end

  context 'The new action' do
    setup do
      @action = :new
    end

    should 'render the default action' do
      flexmock(@controller).should_receive(:render).once.with()
      do_new
    end
  end

  # ==================================================================

  def do_create
    post :create, @params
  end

  context 'The create action' do
    setup do
      @game = Factory(:empty_game)
      @human = Factory.build(:human_player)

      flexmock(HumanPlayer, :new => @human)
      flexmock(Game, :new => @game)

      @params = { :game => { :name => @human.name } }
      flexmock(@controller).should_receive(:render).with().by_default
    end

    should 'include the human player in the game' do
      do_create
      assert @game.players.include?(@human), "Human should be part of game"
    end

    context 'when save succeeds' do
      setup do
        flexmock(@game, :save => true)
      end

      should 'save the game id in a session' do
        do_create
        assert_equal @game.id, session[:game]
      end

      should 'redirect to the choose a player option' do
        do_create
        assert_redirected_to :controller => "games", :action => "choose_players", :id => @game.id
      end
    
      should 'assign a game for the view' do
        do_create
        assert_equal @game, assigns(:game)
      end
    end

    context 'when save fails' do
      setup do
        @human.name = nil
      end

      should 'redirect to new game' do
        do_create
        assert_redirected_to :controller => "games", :action => "new"
      end
      
      should 'assign flash messages' do
        do_create
        assert_match(/can not create game/i, flash[:error])
      end
    end
  end
  
  # ==================================================================
  
  def do_choose_players
    get :choose_players, @params
  end
  
  context 'The choose_players action' do
    setup do
      @game = Factory(:empty_game)
      flexmock(@game, :id => 123)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id }
    end
    
    should 'assign a game' do
      do_choose_players
      assert_equal @game, assigns(:game)
    end

    should 'assign a list of available players' do
      do_choose_players
      assert_equal AutoPlayer.players, assigns(:players)
    end
  end
  
  # ==================================================================

  def do_assign_players
    post :assign_players, @params
  end
  
  context 'The assign_players action' do
    setup do
      @game = Factory(:empty_game)
      @game.players << Factory.build(:human_player, :position => 2)
      should_find(Game, @game).once
      @params = { :id => @game.id.to_s }
    end
    
    should 'assign the game' do
      do_assign_players
      assert_equal @game, assigns(:game)
    end
    
    context 'when the strategy name is blank' do
      setup do
        @params.merge!( :player => "" )
      end

      should 'give a flash error' do
        do_assign_players
        assert_match(/please select/i, flash[:error])
      end

      should 'redirect to choosing a player' do
        do_assign_players
        assert_response :redirect
        assert_redirected_to :choose_players_game
      end
    end

    context 'when the strategy name is given' do
      setup do
        @params.merge!( :player => "randy" )
      end
      
      should 'add the named strategy to the computer player' do
        do_assign_players
        assert_equal "randy", assigns(:game).players.last.strategy
      end

      should 'save the game' do
        flexmock(@game).should_receive(:save).once
        do_assign_players
      end
      
      should 'start the computers turn' do
        do_assign_players
        assert_redirected_to start_turn_path(@game)
      end
    end
  end
end
