class Player < ActiveRecord::Base
  belongs_to :game
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :score
  validates_presence_of :strategy
  validates_numericality_of :score
end
