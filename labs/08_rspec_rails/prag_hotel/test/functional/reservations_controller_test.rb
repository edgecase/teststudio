require File.dirname(__FILE__) + '/../test_helper'

class ApplicationController
  self.send(:public, :render)
  self.send(:public, :render_with_no_layout)
end

class ReservationsControllerTest < ActionController::TestCase

  def test_view
    res = flexmock(:model, Reservation, Reservation.valid_options)
    @controller.assigns =  [res]

    @controller.render_with_no_layout :action => 'index'

    puts @response.body
  end

  def test_url_generating
    assert_generates "/reservations",
      :controller => "reservations", :action => "index"
    assert_generates "/reservations/1",
      :controller => "reservations", :action => "show", :id => "1"
    assert_generates "/reservations/new",
      :controller => "reservations", :action => "new"
    assert_generates "/reservations/1/edit",
      :controller => "reservations", :action => "edit", :id => "1"
    assert_generates "/reservations",
      { :controller => "reservations", :action => "create" },
      { :method => "post" }
    assert_generates "/reservations/1",
      { :controller => "reservations", :action => "update", :id => "1" },
      { :method => "put" }
    assert_generates "/reservations/1",
      { :controller => "reservations", :action => "destroy", :id => "1" },
      { :method => "delete" }
  end

  def test_route_recognition
    assert_recognizes(
      { :controller => "reservations", :action => "index" },
      "/reservations")
    assert_recognizes(
      { :controller => "reservations", :action => "show", :id => "1" },
      "/reservations/1")
    assert_recognizes(
      { :controller => "reservations", :action => "new" },
      "/reservations/new")
    assert_recognizes(
      { :controller => "reservations", :action => "edit", :id => "1" },
      "/reservations/1/edit")
    assert_recognizes(
      {:controller => 'reservations', :action => 'create'},
      {:path => 'reservations', :method => "post"})
    assert_recognizes(
      {:controller => 'reservations', :action => 'update',  :id => "1"},
      {:path => 'reservations/1', :method => "put"})
    assert_recognizes(
      {:controller => 'reservations', :action => 'destroy', :id => "1"},
      {:path => 'reservations/1', :method => "delete"})
  end
  def test_routing
    assert_routing "/reservations",
      :controller => "reservations", :action => "index"
  end

  def test_create_when_save_fails
    invalid_options = Reservation.valid_options
    reservation = flexmock(:model, Reservation, reservation_options)
    reservation.should_receive(:save).once.and_return(false)
    flexmock(Reservation).should_receive(:new).once.and_return(reservation)

    post :create, :reservation => reservation_options

    assert assigns(:availability)
    assert_template "new"
  end  


  def test_new_sets_view_variables
    get :new

    assert_response :success
    assert_template "new"
    assert assigns(:reservation)
    assert assigns(:availability)
  end

  def test_new_defaults_to_today_and_tomorrow
    today = Date.today
    tomorrow = today + 1
    get :new

    assert_date_equal today, assigns(:reservation).check_in
    assert_date_equal tomorrow, assigns(:reservation).check_out
    assert_equal 1, assigns(:reservation).number_of_rooms
  end
  
  def test_new_with_explicit_check_in_and_check_out_dates
    check_in = Date.new(2008, 2, 14)
    check_out = Date.new(2008, 2, 15)

    get :new, :reservation => {
      :check_in => check_in,
      :check_out => check_out,
      :number_of_rooms => 1,
      :rate => 0,
      :room_type_id => 0,
    }

    assert_date_equal check_in, assigns(:reservation).check_in
    assert_date_equal check_out, assigns(:reservation).check_out
  end
  
  def test_new_requests_availability_from_rate_calculator
    king_room = RoomType.new(:name => "King", :rack_rate => 90.0)
    double_room = RoomType.new(:name => "Double", :rack_rate => 80.0)
    flexmock(RoomType).should_receive(:find).with(:all).and_return {
      [ king_room, double_room ]
    }
    check_in = Date.new(2008, 2, 14)
    check_out = Date.new(2008, 2, 15)

    get :new, :reservation => {
      :check_in => check_in,
      :check_out => check_out,
      :number_of_rooms => 1,
      :rate => 0.0,
      :room_type_id => 0,
    }

    assert_availability(king_room, 81, assigns(:availability).first)
    assert_availability(double_room, 72, assigns(:availability).last)
  end

  def test_create_reserves_a_room
    
  end
  
  private

  def assert_availability(room_type, rack_rate, availability)
    assert_equal room_type, availability.first
    assert_in_delta rack_rate, availability.last, 0.000001
  end

  def assert_date_equal(expected_date, actual_date)
    assert_equal expected_date, actual_date,
      "Expected Date #{expected_date}, but got date #{actual_date}"
  end
end
