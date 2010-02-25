require File.dirname(__FILE__) + '/../test_helper'
require 'hpricot'

class ReservationsControllerTest < ActionController::TestCase

  def test_index_view
    res = flexmock(:model, Reservation, Reservation.valid_options)
    flexmock(Reservation).should_receive(:find).and_return([res,res])

    get :index

    doc = Hpricot(@response.body)

    rows = doc /'tr'
    assert_equal 3, rows.size
  end



end
