class Player < ActiveRecord::Base
  validates_presence_of :score
  validates_numericality_of :score

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

  def save_turn!
    last_turn.rolls.each do |r| r.save! end
    save!
  end
end
