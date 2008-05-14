require File.dirname(__FILE__) + '/../test_helper'

class RoomTypeTest < ActiveSupport::TestCase
   def test_should_require_room_type
    @rt = RoomType.new(:name => nil, :rack_rate => 4.00)

    assert_validates_presence_of(:name)
  end

  def test_should_require_rack_rate
    @rt = RoomType.new(
      :name => "Doesn't Matter", 
      :rack_rate => nil)

    assert_validates_presence_of(:rack_rate)
  end
 
  def test_model_validates_uniqueness_of_name
    RoomType.create! :name => 'foo', :rack_rate => 4.00
    @rt = RoomType.new :name => 'foo', :rack_rate => 4.00

    assert_validates_uniqueness_of(:name)
  end

  private

  def assert_validates_presence_of(field)
    assert_validation_with_message(/can't be blank/, field)
  end

  def assert_validates_uniqueness_of(field)
    assert_validation_with_message(/has already been taken/, field)
  end

  def assert_validation_with_message(pattern, field)
    assert ! @rt.valid?
    assert @rt.errors.on(field)
    assert_match(pattern,  
      @rt.errors.on(field).to_s)
  end

end
