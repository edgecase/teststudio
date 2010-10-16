class Turn < ActiveRecord::Base
  has_many :rolls, :order => :position
  belongs_to :player

  def score
    rolls.last.try(:accumulated_score) || 0
  end

  def pending?
    if rolls.nil? || rolls.empty?
      false
    else
      rolls.last.action.blank?
    end
  end
end
