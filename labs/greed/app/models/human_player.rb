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
    current_turn = turns.last
    last_roll = current_turn.try(:rolls).try(:last)
    n = last_roll.try(:unused) || 5
    n = n.nonzero? || 5
    roller.roll(n)
    turn_score = roller.new_score(current_turn.score)
    roll = Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => turn_score,
      :action => nil)
    turns.last.rolls << roll
    roller.bust? ? :bust : :ok
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

