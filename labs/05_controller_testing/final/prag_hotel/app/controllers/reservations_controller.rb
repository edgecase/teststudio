require 'rate_calculator'
class ReservationsController < ApplicationController
  def new
    if params[:reservation]
      @reservation = 
        Reservation.new(params[:reservation])
    else
      @reservation = default_reservation
    end
    update_availability
  end
  
  private

  def default_reservation
    Reservation.new(
      :check_in => Date.today,
      :check_out => Date.today + 1,
      :number_of_rooms => 1,
      :room_type_id => 0,
      :rate => 0)
  end
  
  def update_availability
    rooms = RoomType.find(:all)
    @availability = rooms.collect { |room|
      [
        room,
        RateCalculator.new(room.rack_rate).
        rate(
          @reservation.check_in, 
          @reservation.check_out,
          @reservation.number_of_rooms,
          room.name)
      ]
    }
  end
end
