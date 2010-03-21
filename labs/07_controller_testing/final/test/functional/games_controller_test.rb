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
        assert_redirected_to game_players_path(@game)
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
  
end
