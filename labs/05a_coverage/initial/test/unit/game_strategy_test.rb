require 'test_helper'

class GameStrategyTest < ActiveSupport::TestCase
  context 'A generic game strategy' do
    setup do
      @strategy = GameStrategy.new
    end
    
    should 'never roll again' do
      assert ! @strategy.roll_again?, "should not roll again"
    end
  end
end
