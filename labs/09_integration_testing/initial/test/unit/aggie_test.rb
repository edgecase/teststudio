require 'test_helper'

class AggieTest < ActiveSupport::TestCase
  context 'An aggie game strategy' do
    setup do
      @strategy = Aggie.new
    end
    
    should 'report a name' do
      assert_equal "Aggie", @strategy.name
    end

    should 'report a description' do
      assert_match(/aggressive/i, @strategy.description)
    end

    should 'always roll again' do
      assert @strategy.roll_again?, "should roll again"
    end
  end
end
