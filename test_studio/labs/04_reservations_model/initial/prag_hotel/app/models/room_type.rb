#
# Fields:
#   name         String
#   rack_rate    Decimal
# 
# Requirements:
# * Name is require
# * Name is unique
#
class RoomType < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :rack_rate
  
  validates_uniqueness_of :name

end
