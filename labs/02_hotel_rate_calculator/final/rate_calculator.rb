#  Rules:
#    * Daily rate for room is rack rate minus discount for that day
#    * The rate for a range of dates is the sum of the individual daily rates
#    * Weekdays get a 10% discount off of the rack rate
#    * Weekends get a 20% discount off of the rack rate


class RateCalculator
  def initialize(rack_rate=100)
    @rack_rate = rack_rate
  end

  def rate(check_in_date, check_out_date, rooms)
    rooms * single_room_rate(check_in_date, check_out_date)
  end

  private

  def single_room_rate(check_in_date, check_out_date)
    result = 0.0
    (check_in_date...check_out_date).each do |day|
      result += daily_rate(day)
    end
    result
  end

  def daily_rate(day)
    if weekend?(day)
      daily_amount = 0.80 * @rack_rate
    else
      daily_amount = 0.90 * @rack_rate
    end
  end

  def weekend?(day)
    day.wday == 6 || day.wday == 0
  end
end
