require 'test_helper'

class InteractiveTurnsControllerTest < ActionController::TestCase
  def setup
    super
    @params = {}
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
        assert_redirected_to start_turn_path(@game, @game.computer_player)
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
