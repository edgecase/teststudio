class Turn < ActiveRecord::Base
  has_many :rolls, :order => "position"
  belongs_to :player

  acts_as_list :scope => :player

  def score
    rolls.inject(0) { |sum, roll|
      (roll.action == :bust) ? 0 : sum + roll.points
    }
  end

  def score_up_to(current_roll)
    sum = 0
    rolls.each do |roll|
      if roll.action == :bust
        sum = 0
      else
        sum += roll.points
      end
      break if roll == current_roll
    end
    sum
  end

  def undecided?
    if rolls.nil? || rolls.empty?
      false
    else
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
      result = rolls.last.dice_to_roll
    end
    result
  end
end
