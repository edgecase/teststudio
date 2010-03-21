require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test "should require a name" do
    @model = valid_player_without :name
  
    assert_presence_of :name
  end
  
  test "should require a strategy" do
    @model = valid_player_without :strategy
    
    assert_presence_of :strategy
  end
    
  test "should require a score" do
    @model = valid_player_without :score
  
    assert_presence_of :score
  end
  
  test "should ensure uniqueness of name" do
    valid_player_with(:name => "Duplicate").save
    @model = valid_player_with(:name => "Duplicate")

    assert_uniqueness_of :name
  end
  
  test "should ensure score is a number" do
    @model = valid_player_with(:score => "NAN")
    
    assert_numericality_of :score
  end
  
  test "should belong to a game" do
    association = Player.reflect_on_association :game
    assert_not_nil association
    assert_equal :belongs_to, association.macro
    assert Player.column_names.include?("game_id")
  end
  
  def valid_player_without(attribute)
    Factory.build(:player, attribute => nil)
  end
  
  def valid_player_with(attribute)
    Factory.build(:player, attribute)
  end
  
end
