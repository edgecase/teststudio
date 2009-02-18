require File.dirname(__FILE__) + '/../test_helper'
require 'flexmock/test_unit'

class RoomTypeTest < ActiveSupport::TestCase

  setup do
    # Needs seed record for uniqueness test to fail.
    RoomType.create!(:name => "Sample", :rack_rate => 10.0);
  end

  should_validate_presence_of :rack_rate
  should_validate_presence_of :name
  should_validate_uniqueness_of :name

  should_have_many :reservations
end
