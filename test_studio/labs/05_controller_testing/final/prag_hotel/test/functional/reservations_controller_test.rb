require File.dirname(__FILE__) + '/../test_helper'

class ReservationsControllerTest < ActionController::TestCase

  context 'Action new' do
    context 'with no parameters' do
      setup { get :new }
      
      should_respond_with :success
      should_assign_to :reservation
      should_assign_to :availability
      should_render_template "new"
      
      should 'set checkin for today' do
        assert_date_equal Date.today, assigns(:reservation).check_in
      end
      should 'set checkout to tomorrow' do
        assert_date_equal Date.today+1, assigns(:reservation).check_out
      end
      should 'assign a single room' do
        assert_equal 1, assigns(:reservation).number_of_rooms
      end
    end

    context 'with explicit parameters' do
      setup do
        @king_room = RoomType.new(:name => "King", :rack_rate => 90.0)
        @double_room = RoomType.new(:name => "Double", :rack_rate => 80.0)
        flexmock(RoomType).should_receive(:all).and_return {
          [ @king_room, @double_room ]
        }
        @check_in = Date.new(2008, 2, 14)
        @check_out = Date.new(2008, 2, 15)
        @rooms = 2
        get :new, :reservation => {
          :check_in => @check_in,
          :check_out => @check_out,
          :number_of_rooms => @rooms,
          :rate => 0,
          :room_type_id => 0,
        }
      end

      should_respond_with :success
      should_render_template "new"
      
      should 'set checkin for today' do
        assert_date_equal @check_in, assigns(:reservation).check_in
      end
      should 'set checkout to tomorrow' do
        assert_date_equal @check_out, assigns(:reservation).check_out
      end
      should 'assign the rooms' do
        assert_equal @rooms, assigns(:reservation).number_of_rooms
      end
      should 'assign the availability' do
        assert_availability(@king_room, @rooms * 81, assigns(:availability).first)
        assert_availability(@double_room, @rooms * 72, assigns(:availability).last)
      end
    end

  end

  def test_new_requests_availability_from_rate_calculator
    king_room = RoomType.new(:name => "King", :rack_rate => 90.0)
    double_room = RoomType.new(:name => "Double", :rack_rate => 80.0)
    flexmock(RoomType).should_receive(:all).and_return {
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
    reservation_options = Reservation.valid_options
    reservation = flexmock(:model, Reservation, reservation_options)
    reservation.should_receive(:save).once.and_return(true)
    flexmock(Reservation).should_receive(:new).once.and_return(reservation)

    post :create, :reservation => reservation_options

    assert_match(/saved/i, flash[:message])
    assert_redirected_to :action => "show", :id => reservation.id
  end
  
  def test_create_when_save_fails
    reservation_options = Reservation.valid_options
    reservation = flexmock(:model, Reservation, reservation_options)
    reservation.should_receive(:save).once.and_return(false)
    flexmock(Reservation).should_receive(:new).once.and_return(reservation)

    post :create, :reservation => reservation_options

    assert assigns(:availability)
    assert_template "new"
  end  

  def test_show
    reservation_options = Reservation.valid_options
    reservation = flexmock(:model, Reservation, reservation_options)
    flexmock(Reservation).should_receive(:find).with(reservation.id.to_s).once.and_return(reservation)

    get :show, :id => reservation.id

    assert_equal reservation, assigns(:reservation)
    assert_template "show"
  end

  def test_update_redirects_to_show_on_success
    reservation = flexmock(:model,
      Reservation, :update_attributes => true)
    flexmock(Reservation).should_receive(:find).
      and_return(reservation)

    put :update, :id => reservation.id,
      :reservation => {}

    assert_redirected_to :action => 'show'
  end

  def test_update_renders_edit_on_failure
    reservation = flexmock(:model,Reservation)
    reservation.should_receive(:update_attributes).
      once.with(:options).and_return(false)
    flexmock(Reservation).should_receive(:find).
      and_return(reservation)

    put :update, :id => reservation.id,
      :reservation => :options

    assert_template 'edit'
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
