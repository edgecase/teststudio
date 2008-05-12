
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
    # fill this in
    @rack_rate
  end

end

