#
# Fields:
#   name         String
#   rack_rate    Decimal
#
# Requirements:
# * Name is require
#
class RoomType < ActiveRecord::Base
  has_many :reservations
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :rack_rate

  def self.valid_options
    {
      :name => 'King',
      :rack_rate => 100
    }
  end

end
