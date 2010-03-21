require 'test_helper'

class RandyTest < ActiveSupport::TestCase
  context 'A random game strategy' do
    setup do
      @strategy = Randy.new
    end
    
    should 'report a name' do
      assert_equal "Randy", @strategy.name
    end

    should 'report a description' do
      assert_match(/random/i, @strategy.description)
    end

    should 'sometimes roll and sometimes not' do
      rolls = (1..100).map { @strategy.roll_again? }
      assert rolls.any? { |r| r }, "some rolls should be true"
      assert rolls.any? { |r| !r }, "some rolls should be false"
    end
  end
end
