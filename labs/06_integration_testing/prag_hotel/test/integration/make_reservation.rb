require File.dirname(__FILE__) + '/../test_helper'

class MakeReservationTest < ActionController::IntegrationTest
  fixtures :reservations, :room_types

  def test_creating_a_reservation
    count = Reservation.count

    get "/reservations/new", 
      :reservation => {
        :name => 'Jones',
        :number_of_rooms => 3,
        :check_in => '2007-05-05', 
        :check_out => '2007-05-06' }

    assert_response :success
    assert_template 'new'

    post "/reservations/create",
      :reservation => Reservation.valid_options

    assert_response :redirect

    assert_equal count + 1, Reservation.count
  end

end
