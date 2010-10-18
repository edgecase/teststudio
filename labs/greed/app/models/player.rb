class Player < ActiveRecord::Base
  attr_writer :roller

  has_many :turns, :order => "position"

  def roller
    @roller ||= Roller.new
  end

  def last_action
    last_roll.try(:action)
  end

  def last_turn
    turns.to_a.last
  end

  def last_roll
    last_turn.try(:rolls).to_a.last
  end

  def save_roll!
    last_turn.rolls.each do |r| r.save! end
    save!
  end
end
