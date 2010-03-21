class Face < ActiveRecord::Base
  validates_numericality_of :value
  validates_numericality_of :position
  validates_inclusion_of :value, :in => 1..6,
    :message => 'must be between 1 and 6'
end
