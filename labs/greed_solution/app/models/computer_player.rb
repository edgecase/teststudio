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
      turn_score += roller.points
      if roller.points == 0
        action = :bust
      elsif ! roll_again?
        action = :host
      else
        action = :roll
      end
      history << record_roll(history.last, action)
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
  
  def record_roll(last_roll, action)
    s = (action == :bust) ? 0 : roller.points+(last_roll ? last_roll.score : 0)
    Roll.new(
      :faces => roller.faces.map { |n| Face.new(:value => n) },
      :score => roller.points,
      :unused => roller.unused,
      :accumulated_score => s,
      :action => action)
  end

  def make_strategy
    strategy.constantize.new
  end
end
