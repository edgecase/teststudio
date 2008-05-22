require File.dirname(__FILE__) + '/../../spec_helper'

describe "reservations/index" do
  before :each do
    @reservation_one = flexmock(:model,
      Reservation, Reservation.valid_options)
    @reservation_two = flexmock(:model,
      Reservation, Reservation.valid_options)

    assigns[:reservations] = [ @reservation_one, @reservation_two ]
  end

  it "should have a table" do
    render 'reservations/index'

    response.should have_tag('table')
  end
end
