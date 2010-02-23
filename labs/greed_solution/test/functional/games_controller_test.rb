require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @params = {}
  end

  def do_action
    get @action, @params
  end

  context 'The new action' do
    setup do
      @action = :new
    end

    should 'render the default action' do
      flexmock(@controller).should_receive(:render).once.with()
      do_action
    end
  end

  context 'The create action' do
    setup do
      @human = HumanPlayer.new(:name => "HUMAN")
      @game = Game.new(:human_player => @human)
      
      flexmock(HumanPlayer, :new => @human)
      flexmock(Game, :new => @game)

      @action = :create
      @params = { :game => { :name => "HUMAN" }}
      flexmock(@controller).should_receive(:render).with().by_default
    end

    context 'when save succeeds' do
      setup do
        flexmock(@human).should_receive(:save).and_return(true).once
        flexmock(@game).should_receive(:save).and_return(true).once
        flexmock(@game, :id => 123)
      end

      should 'save the game id in a session' do
        do_action

        assert_equal 123, session[:game]
      end

      should 'redirect to the choose a player option' do
        flexmock(@controller).should_receive(:redirect_to).
          with(path(:choose_players_game_path, @game.id)).
          once
        do_action
      end
    
      should 'assign human player for the view' do
        do_action
        assert_equal @human, assigns(:human_player)
      end

      should 'assign a game for the view' do
        do_action
        assert_equal @game, assigns(:game)
      end

    end
  end
  
  private

  def path(path_function, *args)
    @controller.send(path_function, *args)
  end
end
