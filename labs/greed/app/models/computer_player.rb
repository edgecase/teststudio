class ComputerPlayer < Player
  delegate :name, :description, :roll_again?, :to => :logic

  def play_style
    :automatic
  end

  def strategy=(strategy_name)
    write_attribute(:strategy, strategy_name)
    @logic = nil
  end

  def logic
    @logic ||= get_logic
  end

  def take_turn
    rolls_in_this_turn = []
    turn_score = 0
    dice_to_roll = 5
    begin
      roller.roll(dice_to_roll)
      turn_score = roller.new_score(turn_score)
      if roller.bust?
        action = :bust
      elsif ! roll_again?
        action = :hold
      else
        action = :roll
      end
      rolls_in_this_turn << new_roll(turn_score, action)
      dice_to_roll = number_of_dice_to_roll(roller.unused)
    end while action == :roll
    turn = Turn.new(:rolls => rolls_in_this_turn)
    turns << turn
    self.score += turn.score
    turns.last
  end

  private

  def number_of_dice_to_roll(unused)
    unused.nonzero? || 5
  end

  def new_roll(_unused_, action)
    Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :action => action)
  end

  def get_logic
    if strategy && (strategy_class = strategy.constantize)
      strategy_class.new
    else
      nil
    end
  end
end
