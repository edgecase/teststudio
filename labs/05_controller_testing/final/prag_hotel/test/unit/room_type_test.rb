require File.dirname(__FILE__) + '/../test_helper'

class RoomTypeTest < ActiveSupport::TestCase
  # def test_should_require_room_type
  #   @rt = RoomType.new(
  #     :name => nil, 
  #     :rack_rate => 4.00)
  # 
  #   assert_validates_presence_of :name
  # end
  # 
  # def test_should_require_rack_rate
  #   @rt = RoomType.new(
  #     :name => "Doesn't Matter", 
  #     :rack_rate => nil)
  # 
  #   assert_validates_presence_of :rack_rate
  # end
  #  
  def test_model_validates_uniqueness_of_name
  #   RoomType.create!( 
  #     :name => 'foo', 
  #     :rack_rate => 4.00)
  #   @rt = RoomType.new( 
  #     :name => 'foo', 
  #     :rack_rate => 4.00)
  # 
    assert_validates_uniqueness_of :name
  end
  
  def test_with_new_require
    assert_validates_presence_of :name  
  end

  private


end
