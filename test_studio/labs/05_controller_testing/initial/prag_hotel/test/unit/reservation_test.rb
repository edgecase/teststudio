require File.dirname(__FILE__) + '/../test_helper'

class ReservationTest < ActiveSupport::TestCase

  test_validates_presence_of :name
  test_validates_presence_of :check_in 
  test_validates_presence_of :check_out
  test_validates_presence_of :number_of_rooms 
  test_validates_presence_of :rate
 
  test_validates_numericality_of :number_of_rooms
  
  def test_validates_check_out_is_after_check_in
    assert_check_in_should_be_after_check_out(3.days.from_now, 2.days.from_now)
    assert_check_in_should_be_after_check_out(1.days.from_now, 1.days.from_now)
    
    assert_valid(model_with_dates(1.days.from_now, 2.days.from_now))
  end
  
  private
  def assert_check_in_should_be_after_check_out(check_in, check_out)
    @invalid_model = model_with_dates(check_in, check_out)
    assert_validation_with_message(/must be after checkout/, :check_out)
  end
  
  def model_with_dates(check_in, check_out)
    make_model_with(:check_in => check_in, :check_out => check_out)
  end
  
end
