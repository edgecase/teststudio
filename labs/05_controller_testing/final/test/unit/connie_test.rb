require 'test_helper'

class ConnieTest < ActiveSupport::TestCase
  context 'A connie game strategy' do
    setup do
      @strategy = Connie.new
    end
    
    should 'report a name' do
      assert_equal "Connie", @strategy.name
    end

    should 'report a description' do
      assert_match(/conservative/i, @strategy.description)
    end

    should 'never roll again' do
      assert ! @strategy.roll_again?, "should not roll again"
    end
  end
end
