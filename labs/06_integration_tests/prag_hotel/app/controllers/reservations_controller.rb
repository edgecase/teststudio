require 'rate_calculator'
class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.find(:all)
  end
  
  def new
    if params[:reservation]
      @reservation = 
        Reservation.new(params[:reservation])
    else
      @reservation = default_reservation
    end
    update_availability
  end
  
  def create
    @reservation = Reservation.new(params[:reservation])
    if @reservation.save
      flash[:message] = "Reservation Saved"
      redirect_to :action => "show", :id => @reservation.id
    else
      update_availability
      render :action=>'new'
    end
  end
  
  def show
    @reservation = Reservation.find(params[:id])
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      flash[:message] = "Reservation for #{@reservation.name} deleted"
    else
      flash[:message] = "Reservation for #{@reservation.name} could not be deleted"   
    end
    redirect_to :action => 'index'
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
