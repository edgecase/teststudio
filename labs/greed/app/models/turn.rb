class Turn < ActiveRecord::Base
  has_many :rolls, :order => :position
  belongs_to :player

  def score
    rolls.last.accumulated_score
  end
end
