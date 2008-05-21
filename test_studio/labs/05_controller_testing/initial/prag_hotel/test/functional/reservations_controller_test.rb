require File.dirname(__FILE__) + '/../test_helper'

class ReservationsControllerTest < ActionController::TestCase
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

  def test_new_sets_view_variables
    # Test that when "new" is sent
    #
    # * "new" template is rendered
    # * @reservation and @availability are set
    #
    # ...
  end

  def test_new_defaults_to_today_and_tomorrow
    # Test that when "new" is set:
    #
    # * the reservations check_in and check_out dates default to today
    #   and tomorrow.
    #
    # ...
  end

  def test_new_with_explicit_check_in_and_check_out_dates
    # Test that when "new" is called with explicit check in/out dates:
    #
    # * The reservation check_in/check_out dates are correct.
    #
    # ...
  end
  
  def test_new_requests_availability_from_rate_calculator
    # Test that new correctly sets the availability for King and Double rooms.
    #
    # ...
  end

  def test_create_reserves_a_room
    # Test that create will make a room reservation:
    #
    # * A flash message is created with the word "saved" in it
    # * We redirect to the "show" acdtion with the proper reservation
    #
    # ...
  end
  
  def test_create_when_save_fails
    # Test that when save fails during a create
    #
    # * we update the availability
    # * we render the "new" template
    #
    # ...
  end  

  def test_show
    # Test that show will
    #
    # * assign the correct reservation
    # * renders the "show" template
    #
    # ...
  end

  # For Extra Credit, add test for edit/update/destroy.

  private

  # Some helper functions you might find useful.

  def assert_availability(room_type, rack_rate, availability)
    assert_equal room_type, availability.first
    assert_in_delta rack_rate, availability.last, 0.000001
  end

  def assert_date_equal(expected_date, actual_date)
    assert_equal expected_date, actual_date,
      "Expected Date #{expected_date}, but got date #{actual_date}"
  end
end
