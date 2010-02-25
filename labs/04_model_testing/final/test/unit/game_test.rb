require 'test_helper'

class GameTest < ActiveSupport::TestCase
  
  test "should have many players associated" do
    association = Game.reflect_on_association :players
    assert_not_nil association
    assert_equal :has_many, association.macro
    assert Player.column_names.include?("game_id")
  end

end
