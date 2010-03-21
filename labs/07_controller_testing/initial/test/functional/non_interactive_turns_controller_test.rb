require 'test_helper'

class NonInteractiveTurnsControllerTest < ActionController::TestCase
  # ==================================================================

  context 'The start action' do
    should 'allow the computer to have a turn' do
      # WRITE THIS SPEC
    end
  end

  # ==================================================================

  context 'The results action' do
    context 'when no winner' do
      should 'display turn histories' do
        # WRITE THIS SPEC
      end
      should 'render the computer turn page' do
        # WRITE THIS SPEC
      end
    end

    context 'when the computer wins' do
      should 'assign the winner' do
        # WRITE THIS SPEC
      end
      should 'render the game over' do
        # WRITE THIS SPEC
      end
    end
  end
  
end
