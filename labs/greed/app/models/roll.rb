class Roll < ActiveRecord::Base
  has_many :faces

  def face_values
    faces.map { |f| f.value }
  end

  def points
    100
  end

  def unused
    2
  end

  def action
    action_name.try(:to_sym)
  end

  def action=(new_action)
    self.action_name = new_action.to_s
    if action_name == "bust"
      self.accumulated_score = 0
    end
  end
end
