class HumanPlayer < Player
  def play_style
    :interactive
  end

  def description
    "Human"
  end

  def start_turn
    turns << Turn.new(:rolls => [])
  end

  def roll_dice
    turns.last.roll_dice(roller)
  end

  def goes_bust
    turns.last.rolls.last.action = :bust
  end

  def decides_to_hold
    turns.last.rolls.last.action = :hold
    self.score += turns.last.score
  end

  def decides_to_roll_again
    turns.last.rolls.last.action = :roll
  end

  # True if the last roll of the last turn does not have an action.
  def pending?
    turns.last && turns.last.pending?
  end
end

