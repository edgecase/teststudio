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
      turns.last.rolls.last.action = :bust
    else
      :ok
    end
  end

  def holds
    self.score += turns.last.score
  end

  def rolls_again
    turns.last.rolls.last.action = :roll
  end

  private
  
  def last_roll
    turns.last.rolls.last
  end

  def number_of_dice_to_roll
    count = turns.try(:last).try(:rolls).try(:last).try(:unused)
    case count
    when nil
      5
    when 0
      5
    else
      count
    end
  end
end
