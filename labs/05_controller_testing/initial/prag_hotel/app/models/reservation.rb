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
end
