require File.dirname(__FILE__) + '/../test_helper'

class RoomTypeTest < ActiveSupport::TestCase

  should_validate_presence_of :rack_rate
  should_validate_presence_of :name
  should_validate_uniqueness_of :name

  should_have_many :reservations

end
