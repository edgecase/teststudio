require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================

  # Controller tests issue the get/post/put/delete commands often.
  # So, for each action, we create a special method "do_action" that
  # calls that action with a set of parameters.  Since the parameters
  # will very according to context and setup, we pass the parameters
  # to the method as an instance variable.
  def do_new
    get :new, @params
  end

  # The new action is very simple.  All it needs to do is render the
  # new template.
  context 'The new action' do
    should 'render the default action' do
      do_new
      assert_template "new"
    end
  end

  # ==================================================================

  def do_create
    post :create, @params
  end

  # The top level context for testing the "create" action of the
  # controller.  
  context 'The create action' do
    setup do
      # Create the game and human objects need for the test.  Note the
      # use of factory girl for easy object creation.  We pull the
      # human player into its own instance variable for easy access in
      # other parts of the test.
      #
      @game = Factory(:game)
      @human = @game.human_player

      # Now setup Game and HumanPlayer to return our game and player
      # objects when asked to creat new ones.
      flexmock(HumanPlayer, :new => @human)
      flexmock(Game, :new => @game)

      # Setup the parameters to a default value that is good for most
      # things.
      @params = { :game => { :name => @human.name } }
    end

    # Since the create action saves the game and human player, we want
    # to test a scenario where the save succeeds.  The is part of the
    # "Happy Path".
    context 'when save succeeds' do
      setup do
        flexmock(@game).should_receive(:save).and_return(true).once
        # HACK: Unable to mock for some reason
        def @human.save; true; end
      end

      should 'save the game id in a session' do
        do_create
        assert_equal @game.id, session[:game]
      end

      should 'redirect to the choose a player option' do
        do_create
        assert_redirected_to :action => "choose_players", :id => @game.id
      end
    
      should 'assign human player for the view' do
        do_create
        assert_equal @human, assigns(:human_player)
      end

      should 'assign a game for the view' do
        do_create
        assert_equal @game, assigns(:game)
      end
    end

    # Here is where we start looking at the non-Happy paths.  This
    # scenario looks into what happens if the save to the database
    # fails for some reason.
    context 'when save on human fails' do
      setup do
        # We know that saving the human player without a name is an
        # error.
        @human.name = nil

        # And once the human save fails, the game should never be
        # asked to save itself.
        flexmock(@game).should_receive(:save).never
      end

      should 'redirect to new game' do
        do_create
        assert_redirected_to :action => "new"
      end
      
      should 'assign flash messages' do
        do_create
        assert_match(/can not create game/i, flash[:error])
      end
    end
  end
  
  # ==================================================================
  
  # The choose players action is incomplete in the controller.
  # Implement the specified actions.
  
  def do_choose_players
    get :choose_players, @params
  end
  
  context 'The choose_players action' do
    setup do
      @game = Factory(:game)
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
      @game = Factory(:game)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
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

    context 'when the strategy name is blank' do
      setup do
        @params.merge!( :player => "randy" )
      end
      
      should 'add the named strategy to the ocmputer player' do
        do_assign_players
        assert_equal "randy", assigns(:game).computer_player.strategy
      end

      should 'save the game' do
        flexmock(@game).should_receive(:save).once
        do_assign_players
      end
      
      should 'start the computers turn' do
        do_assign_players
        assert_redirected_to :action => "computer_turn", :id => @game.id
      end
    end
  end
  
  # ==================================================================

  def do_computer_turn
    get :computer_turn, @params
  end

  context 'The computer_turn action' do
    setup do
      # We left the setup here for you to reuse
      @game = Factory(:game)
      @turn = Factory.build(:turn, :player => @computer)
      flexmock(@turn).should_receive(:score => 100)
      @computer = ComputerPlayer.new(:strategy => "Connie", :score => 50)
      @game.computer_player = @computer
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
    end
    
    should 'allow the computer to have a turn' do
      # WRITE THIS SPEC
    end
  end

  # ==================================================================

  def do_computer_turn_results
    post :computer_turn_results, @params
  end

  context 'The computer_turn_results action' do
    setup do
      # WRITE THIS SETUP
    end
    
    context 'when no winner' do
      setup do
        @computer.score = 100
      end
      should 'display turn histories' do
        # WRITE THIS SPEC
      end
      should 'render the computer turn page' do
        # WRITE THIS SPEC
      end
    end

    context 'when the computer wins' do
      setup do
        @computer.score = 3000
      end
      should 'assign the winner' do
        # WRITE THIS SPEC
      end
      should 'render the game over' do
        # WRITE THIS SPEC
      end
    end
  end
  
  # ==================================================================

  def do_human_start_turn
    get :human_start_turn, @params
  end

  context 'The human_start_turn action' do
    setup do
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
    end
    
    should 'start the humans turn' do
      flexmock(@human).should_receive(:start_turn).once
      flexmock(@human).should_receive(:roll_dice).once
      flexmock(@human).should_receive(:save!).once
      do_human_start_turn
    end
  end
  
  # ==================================================================

  def do_human_holds
    get :human_holds, @params
  end

  context 'The human_holds action' do
    setup do
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end
    
    should 'hold the human' do
      # WRITE THIS SPEC
    end
    
    context 'when the human wins' do
      setup do
        flexmock(@human).should_receive(:score).and_return(3000)
      end
      should 'assign a winner' do
        # WRITE THIS SPEC
      end
      should 'show the game over page' do
        # WRITE THIS SPEC
      end
    end

    context 'when there is no winner' do
      setup do
        flexmock(@human).should_receive(:score).and_return(100)
      end

      should 'given the computer a turn' do
        # WRITE THIS SPEC
      end
    end
  end
    
  # ==================================================================

  def do_human_rolls
    get :human_rolls, @params
  end

  context 'The human_rolls action' do
    setup do
      # YOU CAN REUSE THIS SETUP
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end

    should 'tell the human to roll again' do
      # WRITE THIS SPEC
    end

    should 'display the human turn page' do
      # WRITE THIS SPEC
    end
  end
  # ==================================================================

  def do_human_turn
    get :human_turn, @params
  end

  context 'The human_turn action' do
    setup do
      # YOU CAN REUSE THIS SETUP
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end

    should 'set the human rolls' do
      # WRITE THIS SPEC
    end
  end
end
