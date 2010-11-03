class InteractiveTurnsController < ApplicationController
  include NumberSource

  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }
  assume(:last_rolls) { current_player.turns.last.rolls }

  def roll
    if current_player.undecided?
      current_player.decides_to_roll_again
    end
    current_player.roller = Roller.new(number_source)
    roll_result = current_player.roll_dice
    current_player.save_turn!
    if roll_result == :bust
      redirect_to interactive_bust_path(game)
    else
      redirect_to interactive_decide_path(game)
    end
  end

  def bust
    current_player.goes_bust
    current_player.save_turn!
  end

  def decide
  end

  def hold
    current_player.decides_to_hold
    current_player.save_turn!
    redirect_to start_turn_path(game)
  end
end
