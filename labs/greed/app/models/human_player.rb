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

  def holds
    turns.last.rolls.last.action = :hold
    self.score += turns.last.rolls.last.accumulated_score
  end

  def rolls_again
    turns.last.rolls.last.action = :roll
  end

  def pending?
    turns.last && turns.last.pending?
  end
end

