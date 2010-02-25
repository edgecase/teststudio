require 'availability_service'

class RateCalculator
  
  def initialize(rack_rate=100)
    @service = AvailabilityService.new
    @rack_rate = rack_rate
  end
  
  def rate(check_in_date, check_out_date, rooms, room_type)
    availability = @service.availability(check_in_date, room_type)
    (check_in_date ... check_out_date).inject(0) { |sum, day|
      sum + daily_rate(day, rooms, availability) 
    }
  end

  private

  def daily_rate(date, rooms, availability)
    rate = @rack_rate
    if availability > 0.05
      rate = apply_day_of_week_discounts(rate, date)
      rate = apply_number_of_rooms_discounts(rate, rooms)
    end
    rate * rooms
  end

  def apply_day_of_week_discounts(rate, date)
    if date.wday == 6 || date.wday == 0
      rate * 0.8
    else
      rate * 0.9
    end
  end

  def apply_number_of_rooms_discounts(rate, rooms)
    if rooms >= 50
      rate * 0.7 
    elsif rooms >= 10
      rate * 0.8
    else
      rate
    end
  end
end

