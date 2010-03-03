class HumanPlayer < Player
  validates_length_of :name, :within => 1..32
  acts_as_list :scope => :game

  def description
    "Human"
  end
  
  def play_style
    :interactive
  end

  def start_turn
    turn = Turn.new
    turns << turn
  end

  def roll_dice
    roller.roll(number_of_dice_to_roll)
    accumulated_score = roller.points
    accumulated_score += turns.last.rolls.last.accumulated_score unless turns.last.rolls.empty?
    roll = Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => accumulated_score)
    turns.last.rolls << roll
    if roller.points == 0
      most_recent_roll.action = :bust
    else
      :ok
    end
  end
  
  def most_recent_roll
    last_roll
  end

  def holds
    self.score += turns.last.score
  end

  def rolls_again
    last_roll.action = :roll
  end

  private
  
  def last_roll
    turns.try(:last).try(:rolls).try(:last)
  end

  def last_unused
    last_roll.try(:unused) || 0
  end

  def number_of_dice_to_roll
    last_unused.nonzero? || 5
  end
end
