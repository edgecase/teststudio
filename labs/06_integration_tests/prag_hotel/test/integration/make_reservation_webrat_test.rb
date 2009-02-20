require File.dirname(__FILE__) + '/../test_helper'

class MakeReservationWithWebratTest < ActionController::IntegrationTest
  
  def test_making_a_reservation
    count = Reservation.count
    
    visit 'reservations/new'
      
    fill_in "reservation_name", :with => 'Tom Jones'
    
    click_button 'Book This Room'
    
    assert_match /Tom Jones/, response.body
    assert_equal count + 1, Reservation.count
  end


end