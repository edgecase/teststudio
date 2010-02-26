require 'test_helper'

class NonInteractiveTurnsControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
  end
  
  # ==================================================================

  def do_computer_turn
    get :computer_turn, @params
  end

  context 'The computer_turn action' do
    setup do
      @game = Factory(:game)
      @turn = Factory.build(:turn, :player => @computer)
      flexmock(@turn).should_receive(:score => 100)
      @computer = ComputerPlayer.new(:strategy => "Connie", :score => 50)
      @game.computer_player = @computer
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
    end
    
    should 'allow the computer to have a turn' do
      flexmock(@computer).should_receive(:take_turn).and_return(@turn).once
      flexmock(@computer).should_receive(:save).once.and_return(true)
      do_computer_turn
      assert_equal 150, @computer.score
    end
  end

  # ==================================================================

  def do_computer_turn_results
    post :computer_turn_results, @params
  end

  context 'The computer_turn_results action' do
    setup do
      @game = Factory(:game)
      @computer = Factory.build(:computer_player, :score => 50)
      turn = Factory(:turn, :player => @computer)
      @computer.turns << turn
      @game.computer_player = @computer
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
    end
    
    context 'when no winner' do
      setup do
        @computer.score = 100
      end
      should 'display turn histories' do
        do_computer_turn_results
        assert_not_nil assigns(:most_recent_turn)
      end
      should 'render the computer turn page' do
        do_computer_turn_results
        assert_template "computer_turn_results"
      end
    end

    context 'when the computer wins' do
      setup do
        @computer.score = 3000
      end
      should 'assign the winner' do
        do_computer_turn_results
        assert_not_nil assigns(:winner)
      end
      should 'render the game over' do
        do_computer_turn_results
        assert_template "game_over"
      end
    end
  end
  
end
