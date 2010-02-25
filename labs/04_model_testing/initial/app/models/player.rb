class Player < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :score
end
