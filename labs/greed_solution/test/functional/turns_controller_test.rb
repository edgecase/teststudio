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
      @game = Factory(:two_player_game)
      should_find(Game, @game).once
      @params = { :game => @game.id.to_s }
    end
    
    context 'with a human player' do
      setup do
        @human = @game.players.detect { |p| p.is_a?(ComputerPlayer) }
        @game.current_player = @human
        @params.merge!( :player => @human.id.to_s )
      end
      should 'redirect to the interactive controller' do
        do_start_turn
        assert_redirected_to human_start_turn_interactive_turn_path(@game)
      end
    end
    
    context 'with a computer player' do
      setup do
        @computer = @game.players.detect { |p| p.is_a?(HumanPlayer) }
        @game.current_player = @computer
        @params.merge!( :player => @computer.id.to_s )
      end
      should 'redirect to the non-interactive controller' do
        do_start_turn
        assert_redirected_to computer_turn_non_interactive_turn_path(@game)
      end
    end
  end
end
