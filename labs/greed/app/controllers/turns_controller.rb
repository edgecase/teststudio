class TurnsController < ApplicationController
  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }
  assume(:winner_name) { }

  def start_turn
    if current_player.play_style == :automatic
      redirect_to non_interactive_start_path(params[:game_id])
    else
      current_player.start_turn
      current_player.save!
      redirect_to interactive_start_path(params[:game_id])
    end
  end

  def game_over
    self.winner_name = current_player.name
  end
end

