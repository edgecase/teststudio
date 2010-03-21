require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  # ==================================================================

  context 'The new action' do
    should 'render the default action' do
      # WRITE THIS SPEC
    end
  end

  # ==================================================================

  context 'The create action' do
    should 'include the human player in the game' do
      # WRITE THIS SPEC
    end

    context 'when save succeeds' do
      should 'save the game id in a session' do
        # WRITE THIS SPEC
      end

      should 'redirect to the choose a player option' do
        # WRITE THIS SPEC
      end
    
      should 'assign a game for the view' do
        # WRITE THIS SPEC
      end
    end

    context 'when save fails' do
      should 'redirect to new game' do
        # WRITE THIS SPEC
      end
      
      should 'assign flash messages' do
        # WRITE THIS SPEC
      end
    end
  end
  
end
