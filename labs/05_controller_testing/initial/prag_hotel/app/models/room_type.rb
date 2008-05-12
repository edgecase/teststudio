#
# Fields:
#   name         String
#   rack_rate    Decimal
# 
# Requirements:
# * Name is require
# * Name is unique
#
class RoomType < ActiveRecord::Bas
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :rack_rate

end
