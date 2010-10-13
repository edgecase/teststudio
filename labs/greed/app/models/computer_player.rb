class ComputerPlayer < Player
  attr_reader :logic

  def play_style
    :automatic
  end

  delegate :name, :description, :roll_again?, :to => :logic

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
    turns << Turn.new(:rolls => rolls_in_this_turn)
    turns.last
  end

  private

  def number_of_dice_to_roll(unused)
    unused.nonzero? || 5
  end

  def new_roll(turn_score, action)
    Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => turn_score,
      :action => action)
  end

end
