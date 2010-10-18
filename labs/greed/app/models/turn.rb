class Turn < ActiveRecord::Base
  has_many :rolls, :order => :position
  belongs_to :player

  def score
    rolls.inject(0) { |sum, roll|
      (roll.action == :bust) ? 0 : sum + roll.points
    }
  end

  def pending?
    if rolls.nil? || rolls.empty?
      puts "DBG: Turn#pending direct false"
      false
    else
      puts "DBG: rolls.last.action=#{rolls.last.action.inspect}"
      rolls.last.action.blank?
    end
  end

  def roll_dice(roller)
    roller.roll(number_of_dice_to_roll)
    rolls << Roll.new_from_roller(roller, score)
    roller.bust? ? :bust : :ok
  end

  private

  def number_of_dice_to_roll
    if rolls.empty?
      result = 5
    else
      result = rolls.last.unused
    end
    result.nonzero? || 5
  end
end
