class Roll < ActiveRecord::Base
  has_many :faces

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
    action_name.try(:to_sym)
  end

  def action=(new_action)
    self.action_name = new_action.to_s
  end
end
