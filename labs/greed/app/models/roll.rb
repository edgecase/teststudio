class Roll < ActiveRecord::Base
  has_many :faces
  belongs_to :turn

  acts_as_list :scope => :turn

  def self.new_from_roller(roller, _unused_)
    new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
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

  def dice_to_roll
    unused.nonzero? || 5
  end

  def action
    action_name.blank? ? nil : action_name.try(:to_sym)
  end

  def action=(new_action)
    self.action_name = new_action.to_s
  end
end
