class ComputerPlayer < Player

  delegate :name, :description, :roll_again?, :to => :logic
  attr_writer :logic

  acts_as_list :scope => :game

  def play_style
    :automatic
  end

  def logic
    @logic ||= make_strategy
  end

  def take_turn
    history = []
    turn_score = 0
    dice_to_roll = 5
    begin
      roller.roll(dice_to_roll)
      turn_score = roller.new_score(turn_score)
      if roller.bust?
        action = :bust
      elsif ! roll_again?
        action = :host
      else
        action = :roll
      end
      history << new_roll(turn_score, action)
      dice_to_roll = number_of_dice_to_roll(roller.unused)      
    end while action == :roll
    turns << Turn.new(:rolls => history)
    save
    turns.last
  end
  
  private

  def number_of_dice_to_roll(unused)
    (unused == 0) ? 5 : unused
  end
  
  def new_roll(turn_score, action)
    Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => turn_score,
      :action => action)
  end

  def make_strategy
    strategy.constantize.new
  end
end
