#
# Fields:
#   check_in         Date
#   check_out        Date
#   rate             Decimal
#   number_of_rooms  Integer
#   room_type_id     Integer (belongs to a RoomType)
#
# Requirements:
# * All fields are required.
# * rate must be a number
# * number_of_rooms must be a number 
# Extra
# * check_out date must be after check_in date
#
class Reservation < ActiveRecord::Base
  belongs_to :room_type
  
  validates_presence_of :name
  validates_presence_of :check_in
  validates_presence_of :check_out
  validates_presence_of :number_of_rooms
  validates_presence_of :rate
  
  validates_numericality_of :number_of_rooms
  
  def validate
    if check_in && check_out
#      errors.add("check_out", "must be after checkout") unless time_at_midnight(check_in) >= time_at_midnight(check_out)
      ci = time_at_midnight(check_in)
      co = time_at_midnight(check_out)
      puts "Checkin = #{ci}"
      puts "Checkout = #{co}"
      if ((ci > co) || (ci == co))
        errors.add("check_out", "must be after checkout")
      end
    end
  end
  
  def self.valid_options
    {
      :check_in => 2.days.from_now,
      :check_out => 4.days.from_now,
      :rate => 100,
      :number_of_rooms => 1,
      :room_type_id => 1
    }
  end
  
  private
  def time_at_midnight(date_in)
    ds = date_in.to_date
    puts "Date: #{ds}"
    ds
  end
end
