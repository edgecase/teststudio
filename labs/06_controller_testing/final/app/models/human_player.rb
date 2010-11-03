class HumanPlayer < Player
  validates_presence_of :name

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
    last_turn.roll_dice(roller)
  end

  def goes_bust
    last_roll.action = :bust
  end

  def decides_to_hold
    last_roll.action = :hold
    self.score += last_turn.score
  end

  def decides_to_roll_again
    last_roll.action = :roll
  end

  # True if the last roll of the last turn does not have an action.
  def undecided?
    last_turn && last_turn.undecided?
  end

end

