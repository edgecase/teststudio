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
  def pending?
    last_turn && last_turn.pending?
  end

  def last_turn
    turns.to_a.last
  end

  def last_roll
    last_turn.rolls.to_a.last
  end

  def save_roll!
    last_turn.rolls.each do |r| r.save! end
    save!
  end
end

