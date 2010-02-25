require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test "should require a name" do
    valid_player_without :name
  
    assert_presence_of :name
  end
    
  test "should require a score" do
    valid_player_without :score
  
    assert_presence_of :score
  end
  
  test "should ensure uniqueness of name" do
    valid_player_with(:name => "Duplicate").save
    duplicate = 
      valid_player_with(:name => "Duplicate")
      
    assert_uniqueness_of(:name)
  end
  
  def assert_uniqueness_of(attribute)
    assert_validation_with_message(
      /has already been taken/, attribute)
  end
  
  def assert_presence_of(attribute)
    assert_validation_with_message(
      /can't be blank/, attribute)
  end
  
  def assert_validation_with_message(message, attribute)
    assert ! @player.valid?
    assert @player.errors.on(attribute)
    assert_match(message,  
      @player.errors.on(attribute).to_s)
  end
  
  def valid_player_without(attribute)
    @player = Factory.build(
      :player, attribute => nil)
  end
  
  def valid_player_with(attribute)
    @player = Factory.build(
      :player, attribute)
  end
  
  def valid_options_without(attribute)
    valid_options_with(attribute => nil)
  end
  
  def valid_options_with(attribute)
    {
     :name => Faker::Name.name,
     :score => 10
    }.merge(attribute)
  end
  
end
