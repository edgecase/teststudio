require File.dirname(__FILE__) + '/../test_helper'

class RoomTypeTest < ActiveSupport::TestCase

  test_validates_presence_of :rack_rate
  test_validates_presence_of :name
  test_validates_uniqueness_of :name

end
