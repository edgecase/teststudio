require 'test_helper'

class PlaysControllerTest < ActionController::TestCase
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
        assert_not_nil assigns(:turn_histories)
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
      flexmock(@human).should_receive(:holds).once
      flexmock(@human).should_receive(:save!).once.and_return(true)
      do_human_holds
    end
    
    context 'when the human wins' do
      setup do
        flexmock(@human).should_receive(:score).and_return(3000)
      end
      should 'assign a winner' do
        do_human_holds
        assert_equal @human.name, assigns(:winner)
      end
      should 'show the game over page' do
        do_human_holds
        assert_template "game_over"
      end
    end

    context 'when there is no winner' do
      setup do
        flexmock(@human).should_receive(:score).and_return(100)
      end

      should 'given the computer a turn' do
        do_human_holds
        assert_redirected_to :action => "computer_turn"
      end
    end
  end
    
  # ==================================================================

  def do_human_rolls
    get :human_rolls, @params
  end

  context 'The human_rolls action' do
    setup do
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end

    should 'tell the human to roll again' do
      flexmock(@human).should_receive(:rolls_again).once
      flexmock(@human).should_receive(:save!).once
      do_human_rolls
    end

    should 'display the human turn page' do
      do_human_rolls
      assert_redirected_to :action => "human_turn"
    end
  end
  # ==================================================================

  def do_human_turn
    get :human_turn, @params
  end

  context 'The human_turn action' do
    setup do
      @human = Factory.build(:human_player)
      @game = Factory(:game, :human_player => @human)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :id => @game.id.to_s }
      flexmock(@human).should_receive(:holds).by_default
      flexmock(@human).should_receive(:save!).by_default
    end

    should 'set the human rolls' do
      do_human_turn
      assert_equal @human.turns.last.rolls, assigns(:rolls)
    end
  end
end
