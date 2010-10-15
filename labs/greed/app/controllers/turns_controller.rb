class TurnsController < ApplicationController
  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }

  def start_turn
    if current_player.play_style == :automatic
      redirect_to non_interactive_start_path(params[:game_id])
    else
      redirect_to interactive_start_path(params[:game_id])
    end
  end

  def game_over
    @winner = current_player
  end
end
