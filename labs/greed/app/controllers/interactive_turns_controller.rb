class InteractiveTurnsController < ApplicationController
  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }
  assume(:last_rolls) { current_player.turns.last.rolls }

  def roll
    if current_player.pending?
      current_player.rolls_again
    end
    roll_result = current_player.roll_dice
    current_player.save!
    if roll_result == :bust
      redirect_to interactive_bust_path(game)
    else
      redirect_to interactive_decide_path(game)
    end
  end

  def bust
    current_player.goes_bust
    current_player.save!
  end

  def decide
  end

  def hold
    current_player.holds
    current_player.save!
    if current_player.score >= 3000
      redirect_to game_over_path(game)
    else
      redirect_to start_turn_path(game)
    end
  end
end
