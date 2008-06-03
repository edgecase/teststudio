
class RateCalculator
  
  def initialize(rack_rate=100)
    @rack_rate = rack_rate
  end

  #  Add room_type as a parameter, taking either "King" or "Double"
  #  Add the following rules:
  #    * If availability of a room type is under 5%
  #      for any day of a reservation then no discount
  #      will be applied to any day of that reservation
  #    * use the AvailabilityService object to determine
  #      availability for any given day.
  # 
  def rate(check_in_date, check_out_date, rooms)
    (check_in_date ... check_out_date).inject(0) { |sum, day|
      sum + daily_rate(day, rooms) 
    }
  end

  private

  def daily_rate(date, rooms)
    rate = @rack_rate
    rate = apply_day_of_week_discounts(rate, date)
    rate = apply_number_of_rooms_discounts(rate, rooms)
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

