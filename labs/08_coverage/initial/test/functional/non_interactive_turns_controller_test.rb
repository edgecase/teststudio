require 'test_helper'

class NonInteractiveTurnsControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================

  def do_start
    get :start, @params
  end

  context 'The start action' do
    setup do
      @game = Factory(:two_player_game)
      @turn = Factory.build(:turn, :player => @computer)
      flexmock(@turn, :score => 100)
      @computer = computer_player_in(@game)
      @computer.score = 50
      @game.current_player = @computer
      should_find(Game, @game).once
      @params = { :id => @game.id.to_s }
    end
    
    should 'allow the computer to have a turn' do
      flexmock(@computer).should_receive(:take_turn).and_return(@turn).once
      flexmock(@computer).should_receive(:save).once.and_return(true)
      do_start
      assert_equal 150, @computer.score
    end
  end

  # ==================================================================

  def do_results
    post :results, @params
  end

  context 'The results action' do
    setup do
      @game = Factory(:two_player_game)
      @computer = @game.players.detect { |p| p.is_a?(ComputerPlayer) }
      @game.current_player = @computer
      @computer.score = 50
      turn = Factory(:turn, :player => @computer)
      @computer.turns << turn
      should_find(Game, @game).once
      @params = { :id => @game.id.to_s }
    end
    
    context 'when no winner' do
      setup do
        @computer.score = 100
      end
      should 'display turn histories' do
        # WRITE THIS TESTS
      end
      should 'render the computer turn page' do
        # WRITE THIS TEST
      end
    end

    context 'when the computer wins' do
      setup do
        @computer.score = 3000
      end
      should 'assign the winner' do
        # WRITE THIS TESTS
      end
      should 'render the game over' do
        # WRITE THIS TESTS
      end
    end
  end
  
end