class Roll < ActiveRecord::Base
  has_many :faces
  belongs_to :turn

  def self.new_from_roller(roller, turn_score)
    new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => roller.new_score(turn_score),
      :action => nil)
  end

  def face_values
    faces.map { |f| f.value }
  end

  def points
    scorer = Scorer.new
    scorer.score(face_values)
    scorer.points
  end

  def unused
    scorer = Scorer.new
    scorer.score(face_values)
    scorer.unused
  end

  def action
    action_name.blank? ? nil : action_name.try(:to_sym)
  end

  def action=(new_action)
    self.action_name = new_action.to_s
  end
end
