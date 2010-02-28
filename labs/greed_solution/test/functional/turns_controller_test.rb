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
      @game = Factory(:game)
      flexmock(Game).should_receive(:find => @game).with(@game.id.to_s).once
      @params = { :game => @game.id.to_s }
    end
    
    context 'with a human player' do
      setup do
        @human = Factory.build(:human_player)
        @game.human_player = @human
        flexmock(Player).should_receive(:find => @human).with(@human.id.to_s).once
        @params.merge!( :player => @human.id.to_s )
      end
      should 'redirect to the interactive controller' do
        do_start_turn
        assert_redirected_to human_start_turn_interactive_turn_path(@game)
      end
    end
    
    context 'with a computer player' do
      setup do
        @computer = Factory.build(:computer_player)
        @game.computer_player = @computer
        flexmock(Player).should_receive(:find => @computer).with(@computer.id.to_s).once
        @params.merge!( :player => @computer.id.to_s )
      end
      should 'redirect to the non-interactive controller' do
        do_start_turn
        assert_redirected_to computer_turn_non_interactive_turn_path(@game)
      end
    end
  end
end
