class Player < ActiveRecord::Base
  attr_writer :roller

  has_many :turns

  def roller
    @roller ||= Roller.new
  end

  def last_action
    turns.last.try(:rolls).try(:last).try(:action)
  end
end
