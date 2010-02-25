require File.dirname(__FILE__) + '/../test_helper'

class ReservationTest < ActiveSupport::TestCase

  context 'A reservation' do
    should_validate_presence_of :name, :check_in, :check_out, :number_of_rooms, :rate
    should_validate_numericality_of :number_of_rooms

    context 'with a check_out date after the check_in date' do
      setup do
        @reservation = reservation_with_dates(1.day.from_now, 2.days.from_now)
      end
      should 'be valid' do
        assert @reservation.valid?
      end
    end

    context 'with check in and check out dates on the same day' do
      setup do
        @reservation = reservation_with_dates(1.day.from_now, 1.days.from_now)
      end
      should 'not be valid' do
        assert_validation_errors(@reservation, :check_out, /must.*after/i)
      end
    end

    context 'with check in after check out' do
      setup do
        @reservation = reservation_with_dates(2.day.from_now, 1.days.from_now)
      end
      should 'not be valid' do
        assert_validation_errors(@reservation, :check_out, /must.*after/i)
      end
    end
  end

  private
  
  def reservation_with_dates(check_in, check_out)
    make_model_with(Reservation, :check_in => check_in, :check_out => check_out)
  end
  
end
